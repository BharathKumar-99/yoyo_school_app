import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:yoyo_school_app/features/result/model/user_result_model.dart';
import 'package:yoyo_school_app/config/utils/get_user_details.dart';
import 'package:yoyo_school_app/config/utils/global_loader.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:collection/collection.dart';
import '../../common/presentation/global_provider.dart';
import '../../home/model/phrases_model.dart';
import '../../home/model/school_launguage.dart';
import '../../home/model/student_model.dart';
import '../../../config/utils/audio_manager_singleton.dart';
import '../../phrases/data/phrases_deatils_repo.dart';

class PhrasesViewModel extends ChangeNotifier {
  final SchoolLanguage classes;
  final Student? student;
  final bool isGoToNextPhrase;
  int? streak;
  final String? from;
  final AudioManager audioManager = AudioManager();

  // State variables
  List<UserResult> userResult = [];
  List<PhraseModel> newPhrases = [];
  List<PhraseModel> learned = [];
  List<PhraseModel> mastered = [];

  int classPercentage = 0;
  int userPercentage = 0;
  int? streakNumber;

  bool _isDisposed = false;
  bool _isStreakLoading = false;

  final PhrasesDeatilsRepo _repo = PhrasesDeatilsRepo();
  late VoidCallback _userResultListener;
  BuildContext? ctx;
  String? className;
  late GlobalProvider globalProvider;
  int? streakPhraseId;
  int categories;
  bool isMasteryEnabled = false;

  PhrasesViewModel(
    this.classes,
    this.student,
    this.isGoToNextPhrase,
    this.streak,
    this.from,
    this.ctx,
    this.className,
    this.streakPhraseId,
    this.categories,
  ) {
    if (ctx == null) {
      throw Exception(
        "Context must not be null for PhrasesViewModel initialization.",
      );
    }

    // Initial setup
    globalProvider = Provider.of<GlobalProvider>(ctx!, listen: false);
    isMasteryEnabled = globalProvider.apiCred.mastery;

    _isStreakLoading = streak != null || isGoToNextPhrase;

    // Start initialization immediately
    init(true).catchError((e) {
      debugPrint("Error during PhrasesViewModel initialization: $e");
      WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
    });
  }

  bool get isStreakLoading => _isStreakLoading;

  @override
  void dispose() {
    _isDisposed = true;
    try {
      final userResultProvider = Provider.of<GlobalProvider>(
        ctx!,
        listen: false,
      );
      userResultProvider.removeListener(_userResultListener);
    } catch (_) {}
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_isDisposed) super.notifyListeners();
  }

  Future<void> init(bool isFirst) async {
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.show());

    try {
      final userId = GetUserDetails.getCurrentUserId() ?? "";
      final ids =
          classes.language?.phrase?.map((e) => e.id ?? 0).toList() ?? [];

      // 1. Get/Insert Streak
      streakNumber = await _repo.getStreakValue(userId, classes.language?.id);
      if ((streakNumber ?? 0) <= 0) {
        await _repo.insertStreak(userId, classes.language?.id);
      }

      // 2. Initialize Realtime Results
      final userResultProvider = Provider.of<GlobalProvider>(
        ctx!,
        listen: false,
      );
      await userResultProvider.initRealtimeResults(ids);

      // 3. Set up listener
      try {
        userResultProvider.removeListener(_userResultListener);
      } catch (_) {}

      _userResultListener = () {
        if (_isDisposed || ctx == null || !ctx!.mounted) return;
        try {
          _processResults(userId, ids, userResultProvider.results);
          if (isFirst) {
            goToNextScreen();
          }
        } catch (e) {
          debugPrint("Error processing user results: $e");
        }
      };

      userResultProvider.addListener(_userResultListener);

      _isStreakLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint("Failed initializing phrase data: $e");
      rethrow; // Re-throw to be caught by the constructor's catchError
    }
  }

  void _processResults(
    String userId,
    List<int> ids,
    List<UserResult> schoolResults,
  ) {
    if (_isDisposed || ctx == null || !ctx!.mounted) return;

    // Clear and reset lists
    final List<int> classesScore = [];
    final List<int> userScore = [];
    userResult.clear();
    learned.clear();
    mastered.clear();
    newPhrases.clear();

    // 1. Filter and process raw results
    for (final val in schoolResults) {
      if (ids.contains(val.phrasesId)) {
        classesScore.add(val.score ?? 0);
        if (val.userId == userId) {
          userScore.add(val.score ?? 0);
          userResult.add(val);
        }
      }
    }

    // 2. Filter phrases based on category
    final phraseList = classes.language?.phrase?.where((val) {
      if (categories == -1) return val.warmup == true;
      if (categories == 0) return val.categories == null;
      return val.categories == categories;
    }).toList();

    // 3. Categorize phrases (New, Learned, Mastered)
    final availablePhrases = phraseList ?? [];
    for (final phrase in availablePhrases) {
      final result = userResult.firstWhereOrNull(
        (val) => val.phrasesId == phrase.id,
      );

      if (result != null) {
        if (result.type == Constants.mastered) {
          mastered.add(phrase);
        } else if (result.type == Constants.learned) {
          learned.add(phrase);
        }
      } else {
        newPhrases.add(phrase);
      }
    }

    // Ensure uniqueness, though categorization logic should mostly handle this
    learned = learned.toSet().toList();
    mastered = mastered.toSet().toList();

    // 4. Calculate percentages
    final classStrength = student?.classes?.noOfStudents ?? 0;
    final totalClassScore = classesScore.fold(0, (a, b) => a + b);
    final totalUserScore = userScore.fold(0, (a, b) => a + b);

    classPercentage = (classStrength > 0)
        ? (totalClassScore / classStrength).round()
        : 0;

    userPercentage = (userScore.isNotEmpty)
        ? (totalUserScore / userScore.length).round()
        : 0;

    notifyListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
  }

  Future<void> goToNextScreen() async {
    if (_isDisposed || ctx == null || !ctx!.mounted) return;

    try {
      // Remove the specific streak phrase if it exists in the lists
      if (streakPhraseId != null) {
        newPhrases.removeWhere((p) => p.id == streakPhraseId);
        learned.removeWhere((p) => p.id == streakPhraseId);
      }

      if (isGoToNextPhrase &&
          ((from == 'new' && newPhrases.isNotEmpty) ||
              (from == 'learned' && learned.isNotEmpty))) {
        final isNew = from == 'new';
        final phraseToPass = isNew ? newPhrases.first : learned.first;
        final route = isNew ? RouteNames.tryPhrases : RouteNames.masterPhrases;

        ctx!.go(
          route,
          extra: {
            "phrase": phraseToPass,
            "streak": streak,
            "schoolLanguage": classes,
            "className": className,
            "student": student,
            "language": classes.language,
            'categories': categories,
            "isLast": isNew ? newPhrases.length == 1 : learned.length == 1,
          },
        );
      } else {
        // Clear streak value if no phrase is available for navigation
        streak = null;
      }

      _isStreakLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint("Failed navigating to next phrase: $e");
      // Handle navigation error gracefully
    }
  }

  Future<void> playAudio(PhraseModel phraseModel) async {
    try {
      await audioManager.player.setUrl(phraseModel.recording ?? "");
      await audioManager.setVolume(1);
      await play();
    } catch (e) {
      debugPrint("Failed playing audio: $e");
    }
  }

  Future<void> play() async {
    try {
      final player = audioManager.player;

      if (player.playerState.processingState == ProcessingState.completed) {
        await player.seek(Duration.zero);
      }

      await player.play();
    } catch (e) {
      debugPrint("Failed audio playback: $e");
    }
  }

  Future<void> resetPhrase(int? id) async {
    if (id == null) return;
    try {
      GlobalLoader.show();

      // Clear all state to force a full re-build/re-process when data updates
      userResult.clear();
      newPhrases.clear();
      learned.clear();
      mastered.clear();
      classPercentage = 0;
      userPercentage = 0;
      notifyListeners();

      await _repo.resetPhrase(id, student?.id ?? 0);

      // The listener will automatically call _processResults when the
      // GlobalProvider receives the updated results from the repository.
    } catch (e) {
      debugPrint("Failed resetting phrase: $e");
    } finally {
      GlobalLoader.hide();
    }
  }
}
