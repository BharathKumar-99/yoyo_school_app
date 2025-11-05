import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/config/utils/get_user_details.dart';
import 'package:yoyo_school_app/config/utils/global_loader.dart';
import 'package:yoyo_school_app/features/home/model/student_model.dart';
import 'package:yoyo_school_app/features/phrases/data/phrases_deatils_repo.dart';
import 'package:yoyo_school_app/features/result/model/user_result_model.dart';

import '../../../config/utils/audio_manager_singleton.dart';
import '../../home/model/phrases_model.dart';
import '../../home/model/school_launguage.dart';

class PhrasesViewModel extends ChangeNotifier {
  final SchoolLanguage classes;
  final PhrasesDeatilsRepo _repo = PhrasesDeatilsRepo();
  List<UserResult>? schoolResult = [];
  List<UserResult>? userResult = [];
  List<PhraseModel> newPhrases = [];
  List<PhraseModel> learned = [];
  List<PhraseModel> mastered = [];
  bool isGoToNextPhrase = false;
  final Student? student;
  int classPercentage = 0;
  int? streak;
  int? streakNumber;
  int userPercentage = 0;
  List<int> classesScore = [];
  List<int> userScore = [];
  final AudioManager audioManager = AudioManager();

  PhrasesViewModel(this.classes, this.student, this.isGoToNextPhrase,this.streak) {
    init();
  }

  init() async {
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.show());
    final userId = GetUserDetails.getCurrentUserId() ?? "";
    List<int> ids = [];
    classes.language?.phrase?.forEach((val) => ids.add(val.id ?? 0));
    schoolResult = await _repo.getAllUserResults(ids);
    streakNumber = await _repo.getStreakValue(userId, classes.language?.id);
    if ((streakNumber ?? 0) <= 0) {
      await _repo.insertStreak(userId, classes.language?.id);
    }
    learned = [];
    mastered = [];
    newPhrases = [];
    schoolResult?.forEach((val) {
      if (ids.contains(val.phrasesId)) {
        classesScore.add(val.score ?? 0);
        if (val.userId == userId) {
          userScore.add(val.score ?? 0);
          userResult?.add(val);
        }
      }
    });

    userResult?.forEach((val) {
      classes.language?.phrase?.forEach((phrases) {
        if (val.phrasesId == phrases.id) {
          if (val.type == Constants.learned) {
            learned.add(phrases);
          } else if (val.type == Constants.mastered) {
            mastered.add(phrases);
          }
        }
      });
    });
    learned = learned.toSet().toList();
    mastered = mastered.toSet().toList();

    learned.removeWhere((item) => mastered.contains(item));

    classes.language?.phrase?.forEach((val) {
      if (!learned.contains(val) && !mastered.contains(val)) {
        newPhrases.add(val);
      }
    });

    int classStrength = student?.classes?.noOfStudents ?? 0;

    final classScores = classesScore;
    final userScores = userScore;

    final totalClassScore = classScores.isNotEmpty
        ? classScores.reduce((a, b) => a + b)
        : 0;

    final totalUserScore = userScores.isNotEmpty
        ? userScores.reduce((a, b) => a + b)
        : 0;

    final totalClassStrength = classStrength;
    final phraseLength = classes.language?.phrase?.length ?? 0;

    if (totalClassStrength > 0) {
      classPercentage = (totalClassScore / totalClassStrength).round();
    }

    if (phraseLength > 0) {
      userPercentage = (totalUserScore / phraseLength).round();
    }

    notifyListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
    if (isGoToNextPhrase && newPhrases.isNotEmpty) {
      ctx!.pushReplacement(
        RouteNames.tryPhrases,
        extra: {"phrase": newPhrases.first, "streak": streak},
      );
    }
  }

  playAudio(PhraseModel phraseModel) async {
    await audioManager.player.setUrl(phraseModel.recording ?? "");
    await audioManager.setVolume(1);
    await play();
  }

  play() async {
    try {
      final player = audioManager.player;
      if (player.playerState.processingState == ProcessingState.completed) {
        await player.seek(Duration.zero);
      }
      await player.play();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> resetPhrase(int? id) async {
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
    await _repo.resetPhrase(id ?? 0, student?.id ?? 0);
    GlobalLoader.hide();
    await init();
  }
}
