import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_school_app/app.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/utils/get_user_details.dart';
import 'package:yoyo_school_app/core/supabase/supabase_client.dart';
import 'package:yoyo_school_app/features/home/model/level_model.dart';
import 'package:yoyo_school_app/features/home/model/student_model.dart';

class HomeRepository {
  final SupabaseClient _client = SupabaseClientService.instance.client;

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
      ${DbTable.users}(
        *,${DbTable.userResult}(*, ${DbTable.phrase}(*)),
        ${DbTable.studentClasses}(
          *,
          ${DbTable.classes}(
            *,
            ${DbTable.language}(
              *,
              ${DbTable.phrase}(*)
            )
          )
        )
      ),
      ${DbTable.attemptedPhrases}(
        *,
        ${DbTable.phrase}(*)
      )
    ''')
          .eq('user_id', userId)
          .maybeSingle();

      if (data == null) throw Exception("No data found for user $userId");

      final student = Student.fromJson(data);

      if (student.user?.studentClasses != null) {
        student.user?.studentClasses = student.user?.studentClasses!
            .where((sl) => sl.classes?.language?.level == languageLevel)
            .toList();

        for (final schoolLang in student.user!.studentClasses!) {
          final lang = schoolLang.classes?.language;
          if (lang?.phrase != null) {
            lang!.phrase = lang.phrase!
                .where((p) => p.level == languageLevel)
                .toList();
          }
        }
      }
      final disabledIds = globalProvider.apiCred?.phraseDisabledSchools
          .map((e) => e.phraseId)
          .whereType<int>()
          .toSet();

      student.user?.studentClasses?.forEach((classes) {
        classes.classes?.language?.phrase?.removeWhere(
          (phrase) => disabledIds?.contains(phrase.id) ?? false,
        );
      });

      return student;
    } catch (e, st) {
      log("Error fetching student classes: $e", stackTrace: st);
      rethrow;
    }
  }

  Future<Student?> fetchStudents() async {
    final userId = GetUserDetails.getCurrentUserId() ?? "";
    if (userId.isEmpty) throw Exception("User ID not found");
    final response = await _client
        .from(DbTable.student)
        .select('*')
        .eq('user_id', userId)
        .maybeSingle();

    if (response != null) {
      return Student.fromJson(response);
    } else {
      return null;
    }
  }

  Stream<Student?> getUserDataStream() {
    final userId = GetUserDetails.getCurrentUserId() ?? "";

    try {
      return _client
          .from(DbTable.student)
          .stream(primaryKey: ['id'])
          .eq('user_id', userId)
          .map((event) {
            if (event.isNotEmpty) {
              return Student.fromJson(event.first);
            }
            return null;
          });
    } catch (e, st) {
      log('Realtime Student Error: $e\n$st');
      return const Stream.empty();
    }
  }

  Future<int> getTotalAtemptedPhrases(String userId, List<int> ids) async {
    int count = 0;
    final response = await _client
        .from(DbTable.userResult)
        .select('*')
        .eq('score_submited', true)
        .eq('user_id', userId)
        .inFilter('phrases_id', ids)
        .count(CountOption.exact);
    count = response.count;
    return count;
  }
}
