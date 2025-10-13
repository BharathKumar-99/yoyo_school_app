import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/utils/usefull_functions.dart';
import 'package:yoyo_school_app/core/supabase/supabase_client.dart';
import '../model/remote_config_model.dart';
import '../model/speech_evaluation_model.dart';

class ResultsRepo {
  final SupabaseClient _client = SupabaseClientService.instance.client;

  Future<RemoteConfig> getSuperSpeachCred() async {
    final data = await _client
        .from(DbTable.remoteConfig)
        .select()
        .limit(1)
        .maybeSingle();
    return RemoteConfig.fromJson(data!);
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

      // 7️⃣ Parse JSON safely
      final Map<String, dynamic> respJson = jsonDecode(responseString);
      return SpeechEvaluationModel.fromJson(respJson);
    } catch (e, st) {
      log("callSuperSpeechApi Error: $e\n$st");
      return null;
    }
  }
}
