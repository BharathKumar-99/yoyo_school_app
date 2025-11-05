import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import '../../result/model/user_result_model.dart';
import '../data/global_repo.dart';

class GlobalProvider with ChangeNotifier {
  final GlobalRepo _repo = GlobalRepo();

  List<UserResult> _results = [];
  List<UserResult> get results => _results;

  StreamSubscription<List<UserResult>>? _resultSub;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Start listening to realtime updates for the given phrase IDs
  Future<void> initRealtimeResults(List<int> phraseIds) async {
    if (phraseIds.isEmpty) return;

    // If already subscribed, cancel previous subscription
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

  /// Dispose realtime subscription and Supabase channel
  @override
  void dispose() {
    _resultSub?.cancel();
    _repo.disposeStream();
    super.dispose();
  }
}
