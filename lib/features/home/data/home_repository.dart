import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/utils/get_user_details.dart';
import 'package:yoyo_school_app/core/supabase/supabase_client.dart';
import 'package:yoyo_school_app/features/home/model/student_model.dart';

class HomeRepository {
  final SupabaseClient _client = SupabaseClientService.instance.client;

  Future<Student> getClasses() async {
    final userId = GetUserDetails.getCurrentUserId() ?? "";
    if (userId.isEmpty) throw Exception("User ID not found");

    try {
      // 1️⃣ Get student's language level
      final studentInfo = await _client
          .from(DbTable.student)
          .select('language_level')
          .eq('user_id', userId)
          .maybeSingle();

      if (studentInfo == null) throw Exception("Student not found");
      final languageLevel = studentInfo['language_level'];

      // 2️⃣ Fetch complete structure
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
      log(data.toString());
      // 3️⃣ Convert to model
      final student = Student.fromJson(data);

      // 4️⃣ Filter languages and phrases by student's language level
      final school = student.classes?.school;
      if (school != null && school.schoolLanguage != null) {
        // ✅ First, filter the schoolLanguage list
        school.schoolLanguage = school.schoolLanguage!
            .where((sl) => sl.language?.level == languageLevel)
            .toList();

        // ✅ Then, for each remaining language, filter its phrases
        for (final schoolLang in school.schoolLanguage!) {
          final lang = schoolLang.language;
          if (lang?.phrase != null) {
            lang!.phrase = lang.phrase!
                .where((p) => p.level == languageLevel)
                .toList();
          }
        }
      }

      log("Filtered languages and phrases by level $languageLevel");
      return student;
    } catch (e, st) {
      log("Error fetching student classes: $e", stackTrace: st);
      rethrow;
    }
  }
}
