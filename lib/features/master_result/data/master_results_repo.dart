import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/utils/usefull_functions.dart';
import 'package:yoyo_school_app/core/supabase/supabase_client.dart';
import 'package:yoyo_school_app/features/home/model/level_model.dart';
import 'package:yoyo_school_app/features/home/model/student_model.dart';
import 'package:yoyo_school_app/features/result/model/remote_config_model.dart';
import 'package:yoyo_school_app/features/result/model/speech_evaluation_model.dart';
import 'package:yoyo_school_app/features/result/model/user_result_model.dart';
import '../../../config/utils/get_user_details.dart';

class MasterResultsRepo {
  final SupabaseClient _client = SupabaseClientService.instance.client;

  Future<RemoteConfig> getSuperSpeachCred() async {
    final data = await _client
        .from(DbTable.remoteConfig)
        .select()
        .limit(1)
        .maybeSingle();
    return RemoteConfig.fromJson(data!);
  }

  Future<UserResult?> getAttemptedPhrase(int pid) async {
    final userId = GetUserDetails.getCurrentUserId() ?? "";
    final data = await _client
        .from(DbTable.userResult)
        .select('*')
        .eq('user_id', userId)
        .eq('phrases_id', pid)
        .eq('type', Constants.mastered)
        .maybeSingle();
    if (data == null) {
      return null;
    }
    return UserResult.fromJson(data);
  }

  Future<SpeechEvaluationModel?> callSuperSpeechApi({
    required String audioPath,
    required String audioCode,
    required String phrase,
  }) async {
    try {
      RemoteConfig apiCred = await getSuperSpeachCred();
      final wavPath = await UsefullFunctions.convertToWav(audioPath);
      if (wavPath == null || !File(wavPath).existsSync()) {
        log("WAV file not found or conversion failed: $wavPath");
        return null;
      }

      const userId = "123456789";
      final coreType = "sent.eval.$audioCode";
      const audioType = "wav";
      const sampleRate = "16000";
      final appKey = apiCred.apiKey;
      final secretKey = apiCred.apiSecretKey;
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final tokenId = DateTime.now().millisecondsSinceEpoch.toString();

      final connectSig = sha1
          .convert(utf8.encode("$appKey$timestamp$secretKey"))
          .toString();
      final startSig = sha1
          .convert(utf8.encode("$appKey$timestamp$userId$secretKey"))
          .toString();

      final params = {
        "connect": {
          "cmd": "connect",
          "param": {
            "sdk": {"version": 16777472, "source": 9, "protocol": 2},
            "app": {
              "applicationId": appKey,
              "sig": connectSig,
              "timestamp": timestamp,
            },
          },
        },
        "start": {
          "cmd": "start",
          "param": {
            "app": {
              "applicationId": appKey,
              "sig": startSig,
              "userId": userId,
              "timestamp": timestamp,
            },
            "audio": {
              "audioType": audioType,
              "sampleRate": sampleRate,
              "channel": 1,
              "sampleBytes": 2,
            },
            "request": {
              "refText": phrase,
              "coreType": coreType,
              "tokenId": tokenId,
            },
          },
        },
      };

      final uri = Uri.https(UrlConstants.superSpeachApi, coreType);
      final request = http.MultipartRequest("POST", uri)
        ..fields["text"] = jsonEncode(params)
        ..files.add(await http.MultipartFile.fromPath("audio", wavPath))
        ..headers["Request-Index"] = "0";

      final streamedResponse = await request.send();
      final responseString = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode != 200) {
        log("HTTP ${streamedResponse.statusCode}: $responseString");
        return null;
      }

      if (responseString.contains("error")) {
        log("API Error: $responseString");
        return null;
      }

      final Map<String, dynamic> respJson = jsonDecode(responseString);
      return SpeechEvaluationModel.fromJson(respJson);
    } catch (e, st) {
      log("callSuperSpeechApi Error: $e\n$st");
      return null;
    }
  }

  Future<UserResult> upsertResult(UserResult result) async {
    PostgrestMap? data;
    if (result.id != null) {
      data = await _client
          .from(DbTable.userResult)
          .update(result.toJson())
          .eq('id', result.id ?? 0)
          .select("*")
          .maybeSingle();
    } else {
      data = await _client
          .from(DbTable.userResult)
          .insert({
            'user_id': result.userId,
            'phrases_id': result.phrasesId,
            'type': result.type,
            'listen': 1,
          })
          .select("*")
          .maybeSingle();
    }
    return UserResult.fromJson(data!);
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
    } catch (e, st) {
      log("Error fetching student classes: $e", stackTrace: st);
      rethrow;
    }
  }
}
