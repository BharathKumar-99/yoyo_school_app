import 'dart:async';
import 'dart:developer';
import 'package:flutter/widgets.dart';
import '../../result/model/remote_config_model.dart';
import '../../result/model/user_result_model.dart';
import '../data/global_repo.dart';

class GlobalProvider with ChangeNotifier {
  final GlobalRepo _repo = GlobalRepo();

  List<UserResult> _results = [];
  List<UserResult> get results => _results;

  String? version;
  String? code;

  StreamSubscription<List<UserResult>>? _resultSub;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  RemoteConfig? apiCred;

  GlobalProvider._(this.apiCred);

  static Future<GlobalProvider> create() async {
    final repo = GlobalRepo();
    final config = await repo.getRemoteCred();
    return GlobalProvider._(config);
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

  void updateSlack(LanguageSlack lang) {
    try {
      apiCred?.slack = lang;
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
