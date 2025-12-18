import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/utils/global_loader.dart';
import 'package:yoyo_school_app/features/common/presentation/global_provider.dart';
import 'package:yoyo_school_app/features/home/model/school_launguage.dart';
import 'package:yoyo_school_app/features/home/model/student_model.dart';
import 'package:yoyo_school_app/features/phrases/data/phrases_deatils_repo.dart';
import '../../../config/utils/get_user_details.dart';
import '../../result/model/user_result_model.dart';
import '../model/phrase_categories_model.dart';

class PhraseCategoriesViewModel extends ChangeNotifier {
  final SchoolLanguage classes;
  int classPercentage = 0;
  int userPercentage = 0;
  final Student? student;
  List<UserResult> userResult = [];
  List<int> classesScore = [];
  List<int> userScore = [];
  List<PhraseCategoriesModel> phraseCategories = [];
  List<Student> classStudents = [];
  final PhrasesDeatilsRepo _repo = PhrasesDeatilsRepo();
  bool isLoading = true;
  GlobalProvider? globalProvider;

  PhraseCategoriesViewModel(this.classes, this.student) {
    try {
      init();
    } catch (e) {
      throw Exception("Failed to initialize PhrasesViewModel");
    }
  }

  Future<void> init() async {
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.show());
    globalProvider = Provider.of<GlobalProvider>(ctx!);
    final userId = GetUserDetails.getCurrentUserId() ?? "";
    final ids = classes.language?.phrase?.map((e) => e.id ?? 0).toList() ?? [];
    userResult = await _repo.getUserResult(ids);
    classStudents.clear();

    Map<String, List<int>> individualUser = {};
    classStudents = await _repo.getAllClassStudents(student?.classId ?? 0);
    List<String> classUsers = [];
    for (var element in classStudents) {
      classUsers.add(element.userId ?? '');
    }

    for (final val in userResult) {
      if (ids.contains(val.phrasesId) &&
          classUsers.contains(val.userId) &&
          val.user?.isTester != true) {
        final uid = val.userId!;
        individualUser.putIfAbsent(uid, () => []);
        individualUser[uid]!.add(val.score ?? 0);

        if (val.userId == userId) {
          userScore.add(val.score ?? 0);
        }
      }
    }

    createClassScore(individualUser);

    final totalClassScore = classesScore.isEmpty
        ? 0
        : classesScore.reduce((a, b) => a + b);
    final totalUserScore = userScore.isEmpty
        ? 0
        : userScore.reduce((a, b) => a + b);

    if (classesScore.isNotEmpty) {
      classPercentage = (totalClassScore / classesScore.length).round();
    }

    if (userScore.isNotEmpty) {
      userPercentage = (totalUserScore / userScore.length).round();
    }
    phraseCategories = await _repo.getAllPhraseCategories(
      classes.language?.id ?? 0,
      classes.schoolId ?? 0,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      GlobalLoader.hide();
      isLoading = false;
      notifyListeners();
    });
  }

  createClassScore(Map<String, List<int>> user) {
    classesScore = [];
    user.forEach((key, val) {
      classesScore.add(getAvg(val));
    });
  }

  getAvg(List<int> score) {
    int avg = score.reduce((a, b) => a + b);
    return (avg / score.length).round();
  }
}
