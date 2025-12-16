import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/core/supabase/supabase_client.dart';
import 'package:yoyo_school_app/features/home/model/level_model.dart';
import 'package:yoyo_school_app/features/home/model/student_model.dart';
import 'package:yoyo_school_app/features/result/model/user_result_model.dart';
import '../../../config/utils/get_user_details.dart';

class MasterResultsRepo {
  final SupabaseClient _client = SupabaseClientService.instance.client;

  Future<UserResult?> getAttemptedPhrase(int pid) async {
    final userId = GetUserDetails.getCurrentUserId() ?? "";
    final data = await _client
        .from(DbTable.userResult)
        .select('*')
        .eq('user_id', userId)
        .eq('phrases_id', pid)
        .eq('type', Constants.mastered);

    if (data.isEmpty) {
      return null;
    }
    return UserResult.fromJson(data.last);
  }

  Future<UserResult> upsertResult(UserResult result) async {
    PostgrestList? data;
    if (result.id != null) {
      data = await _client
          .from(DbTable.userResult)
          .update(result.toJson())
          .eq('id', result.id ?? 0)
          .select("*");
    } else {
      data = await _client
          .from(DbTable.userResult)
          .insert({
            'user_id': result.userId,
            'phrases_id': result.phrasesId,
            'type': Constants.mastered,
            'listen': 1,
          })
          .select("*");
    }
    return UserResult.fromJson(data.last);
  }

  Future<List<Level>>? getLevel() async {
    List<Level> lvl = [];
    final studentInfo = await _client.from(DbTable.level).select('*');
    for (var va in studentInfo) {
      lvl.add(Level.fromJson(va));
    }
    return lvl;
  }

  Future<Student> getClasses() async {
    final userId = GetUserDetails.getCurrentUserId() ?? "";
    if (userId.isEmpty) throw Exception("User ID not found");

    try {
      final studentInfo = await _client
          .from(DbTable.student)
          .select('language_level')
          .eq('user_id', userId)
          .maybeSingle();

      if (studentInfo == null) throw Exception("Student not found");
      final languageLevel = studentInfo['language_level'];
      final data = await _client
          .from(DbTable.student)
          .select('''
        *,
        ${DbTable.attemptedPhrases}(*,${DbTable.phrase}(*)),
        ${DbTable.classes}(
          *,
          ${DbTable.school}(
            *,
            ${DbTable.schoolLanguage}(
              *,
              ${DbTable.language}(
                *,
                ${DbTable.phrase}(*)
              )
            )
          )
        )
      ''')
          .eq('user_id', userId)
          .maybeSingle();

      if (data == null) throw Exception("No data found for user $userId");

      final student = Student.fromJson(data);

      final school = student.classes?.school;
      if (school != null && school.schoolLanguage != null) {
        school.schoolLanguage = school.schoolLanguage!
            .where((sl) => sl.language?.level == languageLevel)
            .toList();

        for (final schoolLang in school.schoolLanguage!) {
          final lang = schoolLang.language;
          if (lang?.phrase != null) {
            lang!.phrase = lang.phrase!
                .where((p) => p.level == languageLevel)
                .toList();
          }
        }
      }

      return student;
    } catch (e) {
      rethrow;
    }
  }
}
