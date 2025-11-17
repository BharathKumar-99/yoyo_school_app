import 'dart:async';
import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:yoyo_school_app/config/utils/global_loader.dart';
import '../../result/model/remote_config_model.dart';
import '../../result/model/user_result_model.dart';
import '../data/global_repo.dart';

class GlobalProvider with ChangeNotifier {
  final GlobalRepo _repo = GlobalRepo();

  late RemoteConfig apiCred;
  List<UserResult> _results = [];
  List<UserResult> get results => _results;

  String? version;
  String? code;

  StreamSubscription<List<UserResult>>? _resultSub;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  GlobalProvider() {
    init();
  }

  Future<void> init() async {
    try {
      apiCred = await _repo.getRemoteCred();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      version = packageInfo.version;
      code = packageInfo.buildNumber;

      notifyListeners();
    } catch (e, st) {
      log("GlobalProvider init error: $e\n$st");
    }
  }

  Future<void> initRealtimeResults(List<int> phraseIds) async {
    try {
      if (phraseIds.isEmpty) return;

      try {
        await _resultSub?.cancel();
      } catch (e) {
        log("Error canceling previous result stream: $e");
      }

      _repo.disposeStream();

      _isLoading = true;
      notifyListeners();

      final stream = _repo.streamAllUserResults(phraseIds);

      _resultSub = stream.listen(
        (data) {
          try {
            log('Realtime data received: ${data.length} results');
            _results = data;
            _isLoading = false;
            notifyListeners();
          } catch (e) {
            log("Realtime listener inner error: $e");
          }
        },
        onError: (err) {
          log('Error in realtime results: $err');
        },
      );
    } catch (e, st) {
      log('Error initializing realtime results: $e\n$st');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateStreakEnabled(bool value) async {
    try {
      GlobalLoader.show();
      apiCred = await _repo.updateStreakEnabled(value);
      notifyListeners();
    } catch (e, st) {
      log("updateStreakEnabled error: $e\n$st");
    } finally {
      GlobalLoader.hide();
    }
  }

  void updateSlack(LanguageSlack lang) {
    try {
      apiCred.slack = lang;
      notifyListeners();
    } catch (e) {
      log("updateSlack error: $e");
    }
  }

  @override
  void dispose() {
    try {
      _resultSub?.cancel();
    } catch (e) {
      log("GlobalProvider dispose cancel error: $e");
    }

    try {
      _repo.disposeStream();
    } catch (e) {
      log("GlobalProvider dispose stream error: $e");
    }

    super.dispose();
  }
}
