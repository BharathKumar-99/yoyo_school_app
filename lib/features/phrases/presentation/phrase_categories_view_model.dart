import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/utils/global_loader.dart';
import 'package:yoyo_school_app/features/common/presentation/global_provider.dart';
import 'package:yoyo_school_app/features/home/model/language_model.dart';
import 'package:yoyo_school_app/features/home/model/student_model.dart';
import 'package:yoyo_school_app/features/homework/model/home_model.dart';
import 'package:yoyo_school_app/features/phrases/data/phrases_deatils_repo.dart';
import '../../../config/utils/get_user_details.dart';
import '../../result/model/user_result_model.dart';
import '../model/phrase_categories_model.dart';

class PhraseCategoriesViewModel extends ChangeNotifier {
  final Language language;
  int classPercentage = 0;
  int userPercentage = 0;
  final Student? student;
  List<UserResult> userResult = [];
  List<int> classesScore = [];
  HomeworkModel? homeworkModel;
  int homeWorkCompleted = 0;
  List<int> userScore = [];
  List<PhraseCategoriesModel> phraseCategories = [];
  List<Student> classStudents = [];
  final PhrasesDeatilsRepo _repo = PhrasesDeatilsRepo();
  bool isLoading = true;
  GlobalProvider? globalProvider;

  PhraseCategoriesViewModel(this.language, this.student) {
    try {
      init();
    } catch (e) {
      throw Exception("Failed to initialize PhrasesViewModel");
    }
  }

  int getCompletionPercentage({required int completed, required int total}) {
    if (total == 0) return 0;
    return ((completed / total) * 100).toInt();
  }

  Future<void> init() async {
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.show());

    globalProvider = Provider.of<GlobalProvider>(ctx!);
    final userId = GetUserDetails.getCurrentUserId() ?? "";
    final ids = language.phrase?.map((e) => e.id ?? 0).toList() ?? [];
    userResult = await _repo.getUserResult(ids);
    homeworkModel = await _repo.getLatestHomework(student?.user?.school ?? 0);
    if (homeworkModel != null) {
      homeWorkCompleted = await _repo.getCompletedPhraseCount(
        userId: userId,
        homeworkId: homeworkModel?.id ?? 0,
      );
    }
    classStudents.clear();

    Map<String, List<int>> individualUser = {};
    classStudents = await _repo.getAllClassStudents(
      student?.user?.studentClasses != null
          ? student?.user?.studentClasses?.first.classes?.id ?? 0
          : 0,
    );
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
    List<PhraseCategoriesModel> model = await _repo.getAllPhraseCategories(
      language.id ?? 0,
      student?.user?.school ?? 0,
    );
    phraseCategories = [];
    for (var element in model) {
      if (await _repo.checkIfEmpty(element.id ?? 0)) {
        phraseCategories.add(element);
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      GlobalLoader.hide();
      isLoading = false;
      notifyListeners();
    });
  }

  String getDueText(DateTime dueDate) {
    final now = DateTime.now();

    // Normalize to remove time difference issues
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);

    final difference = due.difference(today).inDays;

    if (difference > 0) {
      return 'Due in $difference day${difference == 1 ? '' : 's'}';
    } else if (difference == 0) {
      return 'Due today';
    } else {
      return 'Overdue by ${difference.abs()} day${difference.abs() == 1 ? '' : 's'}';
    }
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
