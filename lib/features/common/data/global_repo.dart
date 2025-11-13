import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/core/supabase/supabase_client.dart';
import 'package:yoyo_school_app/features/common/presentation/global_provider.dart';
import 'package:yoyo_school_app/features/result/model/remote_config_model.dart';
import 'package:yoyo_school_app/features/result/model/speech_evaluation_model.dart';

import '../../../config/constants/constants.dart';
import '../../../config/utils/usefull_functions.dart';
import '../../result/model/user_result_model.dart';

class GlobalRepo {
  final SupabaseClient _client = SupabaseClientService.instance.client;

  RealtimeChannel? _userResultChannel;

  Stream<List<UserResult>> streamAllUserResults(List<int> ids) async* {
    final response = await _client
        .from(DbTable.userResult)
        .select()
        .eq('score_submited', true)
        .inFilter('phrases_id', ids);

    List<UserResult> currentResults = response
        .map<UserResult>((e) => UserResult.fromJson(e))
        .toList();

    final controller = StreamController<List<UserResult>>();

    controller.add(currentResults);

    _userResultChannel = _client.channel('user_result_updates');

    _userResultChannel!
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: DbTable.userResult,

          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'phrases_id',
            value: ids,
          ),
          callback: (payload) async {
            log('Realtime update received: ${payload.toString()}');

            final newResponse = await _client
                .from(DbTable.userResult)
                .select()
                .eq('score_submited', true)
                .inFilter('phrases_id', ids);

            final updatedResults = newResponse
                .map<UserResult>((e) => UserResult.fromJson(e))
                .toList();

            controller.add(updatedResults);
          },
        )
        .subscribe();

    yield* controller.stream;
  }

  Future<RemoteConfig> getRemoteCred() async {
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
      final wavPath = await UsefullFunctions.convertToWav(audioPath);
      if (wavPath == null || !File(wavPath).existsSync()) {
        log("WAV file not found or conversion failed: $wavPath");
        return null;
      }
      GlobalProvider provider = Provider.of<GlobalProvider>(
        ctx!,
        listen: false,
      );
      RemoteConfig apiCred = provider.apiCred;
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

      final streamedResponse = await request.send().timeout(
        Duration(seconds: 10),
      );
      final responseString = await streamedResponse.stream.bytesToString();
      log(responseString);
      if (streamedResponse.statusCode != 200) {
        log("HTTP ${streamedResponse.statusCode}: $responseString");
        return null;
      }

      if (responseString.contains("error")) {
        log("API Error: $responseString");
        return null;
      }

      final Map<String, dynamic> respJson = jsonDecode(responseString);
      SpeechEvaluationModel data = SpeechEvaluationModel.fromJson(respJson);
      num bonus = audioCode == 'fr'
          ? apiCred.slack.fr
          : audioCode == 'ru'
          ? apiCred.slack.ru
          : audioCode == 'sp'
          ? apiCred.slack.sp
          : audioCode == 'de'
          ? apiCred.slack.de
          : audioCode == 'kr'
          ? apiCred.slack.kr
          : audioCode == 'promax.cn'
          ? apiCred.slack.promaxCn
          : audioCode == 'jp'
          ? apiCred.slack.jp
          : audioCode == 'promax'
          ? apiCred.slack.promax
          : 0.0;

      if (data.result?.overall != null) {
        num overall = data.result!.overall ?? 0;

        if (overall <= 0) {
          overall = 0;
        } else {
          overall = overall * (1 + bonus / 100);
        }

        data.result!.overall = overall.clamp(0, 100).toInt();
      }

      return data;
    } catch (e, st) {
      log("callSuperSpeechApi Error: $e\n$st");
      return null;
    }
  }

  Future<ChatGptResponse?> getSpeechFeedback(SpeechEvaluationModel data) async {
    try {
      final scoreData = SpeechEvaluationModel.extractScores(data.toJson());

      final response = await http
          .post(
            Uri.parse(UrlConstants.openAiUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'data': scoreData,
              'threshold': Constants.minimumSubmitScore,
            }),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              log("Chat Gpt Error: Request timed out after 10 seconds");
              throw TimeoutException("Chat Gpt API timeout");
            },
          );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return ChatGptResponse.fromJson(body);
      } else {
        log("Chat Gpt Error: HTTP ${response.statusCode} - ${response.body}");
        return null;
      }
    } on TimeoutException catch (_) {
      log("Chat Gpt Error: Request timed out");
      return null;
    } catch (e, st) {
      log("Chat Gpt Error: $e\n$st");
      return null;
    }
  }

  void disposeStream() {
    if (_userResultChannel != null) {
      _client.removeChannel(_userResultChannel!);
      _userResultChannel = null;
    }
  }

  updateStreak(int? lid, String uid, int streak) async {
    final response = await _client
        .from(DbTable.streakTable)
        .select('max_streak')
        .eq('user_id', uid)
        .eq('language_id', lid ?? 0)
        .maybeSingle();

    int currentStreak = response?['max_streak'] ?? 0;

    if (currentStreak < streak) {
      await _client
          .from(DbTable.streakTable)
          .update({'max_streak': streak})
          .eq('user_id', uid)
          .eq('language_id', lid ?? 0);
    }
  }

  Future<RemoteConfig> updateStreakEnabled(bool value) async {
    final data = await _client
        .from(DbTable.remoteConfig)
        .update({"streak": value})
        .eq('id', 1)
        .select()
        .single();
    return RemoteConfig.fromJson(data);
  }

  Future<RemoteConfig> updateSlack(double frenchSlackNum) async {
    final data = await _client
        .from(DbTable.remoteConfig)
        .update({"fr_slack": frenchSlackNum})
        .eq('id', 1)
        .select()
        .single();
    return RemoteConfig.fromJson(data);
  }
}
