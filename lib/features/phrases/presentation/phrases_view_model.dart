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
import '../../common/presentation/global_provider.dart';
import '../../home/model/phrases_model.dart';
import '../../home/model/school_launguage.dart';
import '../../home/model/student_model.dart';
import '../../../config/utils/audio_manager_singleton.dart';
import '../../phrases/data/phrases_deatils_repo.dart';

class PhrasesViewModel extends ChangeNotifier {
  final SchoolLanguage classes;
  final Student? student;
  bool isGoToNextPhrase;
  int? streak;
  final String? from;
  final AudioManager audioManager = AudioManager();
  List<UserResult> schoolResult = [];
  List<UserResult> userResult = [];
  final PhrasesDeatilsRepo _repo = PhrasesDeatilsRepo();
  List<int> classesScore = [];
  List<int> userScore = [];
  List<PhraseModel> newPhrases = [];
  List<PhraseModel> learned = [];
  List<PhraseModel> mastered = [];
  bool _isDisposed = false;
  int classPercentage = 0;
  int userPercentage = 0;
  int? streakNumber;
  late VoidCallback _userResultListener;
  BuildContext? ctx;
  bool isStreakLoading = false;
  String? className;
  late GlobalProvider globalProvider;
  int? streakPhraseId;

  PhrasesViewModel(
    this.classes,
    this.student,
    this.isGoToNextPhrase,
    this.streak,
    this.from,
    this.ctx,
    this.className,
    this.streakPhraseId,
  ) {
    try {
      globalProvider = Provider.of<GlobalProvider>(ctx!, listen: false);
      isStreakLoading = streak != null || isGoToNextPhrase;

      Future.delayed(Duration.zero, () {
        Future.delayed(Duration.zero, () {
          init(true);
        });
      });
    } catch (e) {
      throw Exception("Failed to initialize PhrasesViewModel");
    }
  }

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

      try {
        streakNumber = await _repo.getStreakValue(userId, classes.language?.id);
      } catch (_) {
        throw Exception("Failed loading streak data");
      }

      if ((streakNumber ?? 0) <= 0) {
        try {
          await _repo.insertStreak(userId, classes.language?.id);
        } catch (_) {
          throw Exception("Failed saving streak");
        }
      }

      final userResultProvider = Provider.of<GlobalProvider>(
        ctx!,
        listen: false,
      );

      try {
        await userResultProvider.initRealtimeResults(ids);
      } catch (_) {
        throw Exception("Failed starting realtime results");
      }

      try {
        userResultProvider.removeListener(_userResultListener);
      } catch (_) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => GlobalLoader.hide(),
        );
      }

      _userResultListener = () {
        if (_isDisposed) return;
        try {
          schoolResult = userResultProvider.results;
          _processResults(userId, ids, isFirst);
        } catch (_) {
          throw Exception("Failed processing user results");
        }
      };

      userResultProvider.addListener(_userResultListener);
    } catch (e) {
      throw Exception("Failed initializing phrase data");
    }
  }

  void _processResults(String userId, List<int> ids, bool isFirst) async {
    try {
      if (_isDisposed || ctx == null || !ctx!.mounted) return;

      classesScore.clear();
      userScore.clear();
      userResult.clear();
      learned = [];
      mastered = [];
      newPhrases = [];

      for (final val in schoolResult) {
        if (ids.contains(val.phrasesId)) {
          classesScore.add(val.score ?? 0);
          if (val.userId == userId) {
            userScore.add(val.score ?? 0);
            userResult.add(val);
          }
        }
      }

      for (final val in userResult) {
        for (final phrase in classes.language?.phrase ?? []) {
          if (val.phrasesId == phrase.id) {
            if (val.type == Constants.learned) {
              learned.add(phrase);
            } else if (val.type == Constants.mastered) {
              mastered.add(phrase);
            }
          }
        }
      }

      learned = learned.toSet().toList();
      mastered = mastered.toSet().toList();
      learned.removeWhere((p) => mastered.contains(p));

      for (final phrase in classes.language?.phrase ?? []) {
        if (!learned.contains(phrase) && !mastered.contains(phrase)) {
          newPhrases.add(phrase);
        }
      }

      final classStrength = student?.classes?.noOfStudents ?? 0;
      final totalClassScore = classesScore.isEmpty
          ? 0
          : classesScore.reduce((a, b) => a + b);
      final totalUserScore = userScore.isEmpty
          ? 0
          : userScore.reduce((a, b) => a + b);

      if (classStrength > 0) {
        classPercentage = (totalClassScore / classStrength).round();
      }

      if (userScore.isNotEmpty) {
        userPercentage = (totalUserScore / userScore.length).round();
      }

      notifyListeners();

      WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());

      if (isFirst) {
        await goToNextScreen();
      }
    } catch (e) {
      throw Exception("Failed processing class/user data");
    }
  }

  Future<void> goToNextScreen() async {
    try {
      if (streakPhraseId != null) {
        newPhrases.removeWhere((p) => p.id == streakPhraseId);
        learned.removeWhere((p) => p.id == streakPhraseId);
      }

      final data = await _repo.getUserResults();

      List<UserResult> merged = [];

      for (var element in data) {
        for (var newElement in userResult) {
          if (newElement.phrasesId == element.phrasesId) {
            merged.add(element);
          }
        }
      }

      userResult = merged;

      for (final val in userResult) {
        for (final phrase in classes.language?.phrase ?? []) {
          if (val.phrasesId == phrase.id) {
            if (val.type == Constants.learned && val.scoreSubmitted == false) {
              learned.add(phrase);
            } else if (val.type == Constants.mastered &&
                val.scoreSubmitted == false) {
              mastered.add(phrase);
            }
          }
        }
      }

      if (isGoToNextPhrase &&
          ((from == 'new' && newPhrases.isNotEmpty) ||
              (from == 'learned' && learned.isNotEmpty))) {
        ctx!.go(
          from == 'new' ? RouteNames.tryPhrases : RouteNames.masterPhrases,
          extra: {
            "phrase": from == 'new' ? newPhrases.first : learned.first,
            "streak": streak,
            "schoolLanguage": classes,
            "className": className,
            "student": student,
            "language": classes.language,
            "isLast": from == 'new'
                ? newPhrases.length == 1
                : learned.length == 1,
          },
        );
      } else {
        streak = null;
      }

      isStreakLoading = false;
    } catch (e) {
      throw Exception("Failed navigating to next phrase");
    }
  }

  Future<void> playAudio(PhraseModel phraseModel) async {
    try {
      await audioManager.player.setUrl(phraseModel.recording ?? "");
      await audioManager.setVolume(1);
      await play();
    } catch (_) {
      throw Exception("Failed playing audio");
    }
  }

  Future<void> play() async {
    try {
      final player = audioManager.player;

      if (player.playerState.processingState == ProcessingState.completed) {
        await player.seek(Duration.zero);
      }

      await player.play();
    } catch (_) {
      throw Exception("Failed audio playback");
    }
  }

  Future<void> resetPhrase(int? id) async {
    try {
      GlobalLoader.show();

      schoolResult = [];
      userResult = [];
      newPhrases = [];
      learned = [];
      mastered = [];
      classPercentage = 0;
      userPercentage = 0;
      classesScore = [];
      userScore = [];
      notifyListeners();

      await _repo.resetPhrase(id ?? 0, student?.id ?? 0);

      final ids =
          classes.language?.phrase?.map((e) => e.id ?? 0).toList() ?? [];

      final provider = Provider.of<GlobalProvider>(ctx!, listen: false);

      await provider.initRealtimeResults(ids);
    } catch (_) {
      throw Exception("Failed resetting phrase");
    } finally {
      GlobalLoader.hide();
    }
  }
}
