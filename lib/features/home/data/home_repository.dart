import 'dart:convert';
import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_school_app/app.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/utils/get_user_details.dart';
import 'package:yoyo_school_app/core/supabase/supabase_client.dart';
import 'package:yoyo_school_app/features/home/model/level_model.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';
import 'package:yoyo_school_app/features/home/model/school_model.dart';
import 'package:yoyo_school_app/features/home/model/student_model.dart';
import 'package:yoyo_school_app/features/homework/model/home_model.dart';
import 'package:yoyo_school_app/features/profile/model/user_deatils_mode.dart';
import 'package:yoyo_school_app/features/result/model/user_result_model.dart';

import '../../phrases/model/phrase_categories_model.dart';
import '../../profile/model/fcm.dart';
import '../model/student_classes.dart';

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
      // Step 1: Get student language level
      final studentInfo = await _client
          .from(DbTable.student)
          .select('language_level')
          .eq('user_id', userId)
          .maybeSingle();

      if (studentInfo == null) throw Exception("Student not found");

      final languageLevel = studentInfo['language_level'];

      // Step 2: Fetch full student data
      final data = await _client
          .from(DbTable.student)
          .select('''
      *,
      ${DbTable.users}(
        *,
        ${DbTable.userResult}(*, ${DbTable.phrase}(*)),
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

      if (data == null) {
        throw Exception("No data found for user $userId");
      }

      final student = Student.fromJson(data);

      // Step 3: Filter classes by language level
      final studentClasses = student.user?.studentClasses;
      if (studentClasses != null) {
        student.user!.studentClasses = studentClasses
            .where((sc) => sc.classes?.language?.level == languageLevel)
            .toList();
      }

      // Step 4: Get disabled phrase IDs
      final disabledIds = globalProvider.apiCred?.phraseDisabledSchools
          .map((e) => e.phraseId)
          .whereType<int>()
          .toSet();

      // Step 5: Fetch categories ONCE (optimization)
      final firstClass = student.user?.studentClasses?.isNotEmpty == true
          ? student.user!.studentClasses!.first
          : null;

      Set<int> allowedPhraseIds = {};

      final langId = firstClass?.classes?.language?.id ?? 0;
      final schoolId = student.user!.school!;

      final categories = await getAllPhraseCategories(langId, schoolId);

      for (var val in categories) {
        if (val.phrases != null) {
          for (var p in val.phrases!) {
            allowedPhraseIds.add(p.id ?? 0);
          }
        }
      }

      // Step 6: Filter phrases
      for (final sc in student.user?.studentClasses ?? []) {
        final lang = sc.classes?.language;

        if (lang?.phrase != null) {
          lang!.phrase = lang.phrase!
              .where(
                (p) =>
                    p.level == languageLevel &&
                    p.categories != null &&
                    (allowedPhraseIds.isEmpty ||
                        allowedPhraseIds.contains(p.id)) &&
                    !(disabledIds?.contains(p.id) ?? false),
              )
              .toList();
        }
      }

      return student;
    } catch (e, st) {
      log("Error fetching student classes: $e", stackTrace: st);
      rethrow;
    }
  }

  Future<List<PhraseCategoriesModel>> getAllPhraseCategories(
    int id,
    int schoolId,
  ) async {
    final response = await _client
        .from(DbTable.phraseCategories)
        .select('''*,${DbTable.phrase}(*)''')
        .eq('language', id)
        .or('school_id.eq.$schoolId,school_id.is.null')
        .eq('Active', true)
        .order('item_index', ascending: true);
    return response
        .map<PhraseCategoriesModel>((e) => PhraseCategoriesModel.fromJson(e))
        .toList();
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

  Future<School?> getSchoolData(int id) async {
    try {
      final data = await _client
          .from(DbTable.school)
          .select(
            '''*,${DbTable.classes}(*,${DbTable.language}(*,${DbTable.level}(*),${DbTable.phrase}(id, language, homework_id)),${DbTable.studentClasses}(*, ${DbTable.users}(*,${DbTable.student}(*),${DbTable.userResult}(id, phrases_id, score, score_submited, ${DbTable.phrase}(id, language)))))''',
          )
          .eq('id', id)
          .maybeSingle();
      return School.fromJson(data!);
    } catch (e) {
      return null;
    }
  }

  Future<List<HomeworkModel>> getHomeWorkModel(
    int schoolId,
    int language,
  ) async {
    try {
      List<HomeworkModel> model = [];
      final data = await _client
          .from(DbTable.homework)
          .select('*, ${DbTable.phrase}!inner(*)')
          .eq('school', schoolId)
          .eq('${DbTable.phrase}.language', language)
          .order('created_at', ascending: false);

      for (var e in data) {
        model.add(HomeworkModel.fromJson(e));
      }
      model = model.where((e) => (e.phrases?.isNotEmpty ?? false)).toList();
      return model;
    } catch (e) {
      return [];
    }
  }

  Future<List<PhraseModel>> getHomeworkPhrase(int? id) async {
    if (id == null) return [];

    final response = await _client
        .from(DbTable.phrase)
        .select()
        .eq('homework_id', id);

    return (response as List).map((e) => PhraseModel.fromJson(e)).toList();
  }

  Future<List<UserResult>> getHomeWorkResults(List<int> ids) async {
    if (ids.isEmpty) return [];

    final response = await _client
        .from(DbTable.userResult)
        .select('*')
        .inFilter('phrases_id', ids);

    return (response as List).map((e) => UserResult.fromJson(e)).toList();
  }

  Future<void> sendNotification(int classId) async {
    List<StudentClassesModel> studentClass = await getStudents(classId);
    List<String> fcmId = [];

    for (var element in studentClass) {
      for (Fcm fcm in element.user?.fcm ?? []) {
        if (fcm.fcmId != null && fcm.fcmId!.isNotEmpty) {
          fcmId.add(fcm.fcmId!);
        }
      }
    }

    final tokens = fcmId
        .where((e) => e.toString().trim().isNotEmpty)
        .map((e) => e.toString())
        .toList();

    final payload = jsonEncode({
      'message': 'New Homework Added',
      'token': tokens,
    });

    print("SENDING PAYLOAD: $payload");
    final res = await _client.functions.invoke(
      'send_notification',
      body: payload,
      headers: {'Content-Type': 'application/json'},
    );

    print("RESPONSE: ${res.data}");
  }

  Future<List<StudentClassesModel>> getStudents(int classId) async {
    List<StudentClassesModel> students = [];
    final data = await _client
        .from(DbTable.studentClasses)
        .select('''*,${DbTable.users}(*)''')
        .eq('classes', classId);

    for (var element in data) {
      students.add(StudentClassesModel.fromJson(element));
    }

    return students;
  }

  Future<List<UserDetailsModel>> getDetails(int i) async {
    final data = await _client
        .from('user_student_view')
        .select()
        .eq('class_id', i);
    List<UserDetailsModel> model = [];
    for (var element in data) {
      model.add(UserDetailsModel.fromJson(element));
    }
    return model;
  }
}
