import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/utils/get_user_details.dart';
import 'package:yoyo_school_app/core/supabase/supabase_client.dart';
import 'package:yoyo_school_app/features/home/model/level_model.dart';
import 'package:yoyo_school_app/features/home/model/student_model.dart';
import 'package:yoyo_school_app/features/listen_and_type_result/model/listen_model.dart';
import 'package:yoyo_school_app/features/result/model/user_result_model.dart';

class ListenRepo {
  final SupabaseClient _client = SupabaseClientService.instance.client;

  Future<UserResult?> getAttemptedPhrase(int pid) async {
    final userId = GetUserDetails.getCurrentUserId() ?? "";
    final data = await _client
        .from(DbTable.userResult)
        .select('*')
        .eq('user_id', userId)
        .eq('phrases_id', pid)
        .eq('type', Constants.learned);

    if (data.isEmpty) {
      return null;
    }
    return UserResult.fromJson(data.last);
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
        *,${DbTable.users}(*,${DbTable.studentClasses}(*, ${DbTable.classes}(*,  ${DbTable.language}(
            *,
            ${DbTable.phrase}(*)
          )
        )))),
        ${DbTable.attemptedPhrases}(*,${DbTable.phrase}(*)),
        ${DbTable.classes}(
          *,
          ${DbTable.language}(
            *,
            ${DbTable.phrase}(*)
          )
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

      return student;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Level>>? getLevel() async {
    List<Level> lvl = [];
    final studentInfo = await _client.from(DbTable.level).select('*');
    for (var va in studentInfo) {
      lvl.add(Level.fromJson(va));
    }
    return lvl;
  }

  Future<ListenModel> getTextResult(String typed, String phraseModel) async {
    final url = Uri.parse(
      'https://xijaobuybkpfmyxcrobo.supabase.co/functions/v1/evaluate_listening',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'original': phraseModel, 'student': typed}),
    );

    if (response.statusCode != 200) {
      throw Exception('Edge function failed');
    }
    final cleaned = cleanJsonResponse(response.body);

    final Map<String, dynamic> json = jsonDecode(cleaned);
    return ListenModel.fromJson(json);
  }

  String cleanJsonResponse(String input) {
    return input
        .replaceAll(RegExp(r'^```json\s*', multiLine: true), '')
        .replaceAll(RegExp(r'^```\s*', multiLine: true), '')
        .replaceAll(RegExp(r'\s*```$', multiLine: true), '')
        .trim();
  }

  Future<UserResult?>? upsertResult(UserResult result) async {
    final PostgrestList data;
    try {
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
              'type': Constants.learned,
            })
            .select("*");
      }
      return UserResult.fromJson(data.last);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
