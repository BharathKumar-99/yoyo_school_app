import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import '../../result/model/remote_config_model.dart';
import '../../result/model/user_result_model.dart';
import '../data/global_repo.dart';

class GlobalProvider with ChangeNotifier {
  final GlobalRepo _repo = GlobalRepo();
  late RemoteConfig apiCred;
  List<UserResult> _results = [];
  List<UserResult> get results => _results;

  StreamSubscription<List<UserResult>>? _resultSub;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  GlobalProvider() {
    init();
  }

  init() async {
    apiCred = await _repo.getRemoteCred();
  }

  Future<void> initRealtimeResults(List<int> phraseIds) async {
    if (phraseIds.isEmpty) return;

    await _resultSub?.cancel();
    _repo.disposeStream();

    _isLoading = true;
    notifyListeners();

    try {
      final stream = _repo.streamAllUserResults(phraseIds);
      _resultSub = stream.listen(
        (data) {
          log('Realtime data received: ${data.length} results');
          _results = data;
          _isLoading = false;
          notifyListeners();
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

  @override
  void dispose() {
    _resultSub?.cancel();
    _repo.disposeStream();
    super.dispose();
  }
}
