import 'package:flutter/material.dart';
import 'package:yoyo_school_app/config/utils/global_loader.dart';
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
  final PhrasesDeatilsRepo _repo = PhrasesDeatilsRepo();
  bool isLoading = true;

  PhraseCategoriesViewModel(this.classes, this.student) {
    try {
      init();
    } catch (e) {
      throw Exception("Failed to initialize PhrasesViewModel");
    }
  }

  Future<void> init() async {
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.show());
    final userId = GetUserDetails.getCurrentUserId() ?? "";
    final ids = classes.language?.phrase?.map((e) => e.id ?? 0).toList() ?? [];
    userResult = await _repo.getUserResult(ids);

    for (final val in userResult) {
      classesScore.add(val.score ?? 0);
      if (val.userId == userId) {
        userScore.add(val.score ?? 0);
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
    phraseCategories = await _repo.getAllPhraseCategories(
      classes.language?.id ?? 0,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      GlobalLoader.hide();
      isLoading = false;
      notifyListeners();
    });
  }
}
