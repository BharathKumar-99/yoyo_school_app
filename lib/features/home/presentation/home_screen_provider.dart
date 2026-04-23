import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/features/home/data/home_repository.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';
import 'package:yoyo_school_app/features/home/model/student_classes.dart';
import 'package:yoyo_school_app/features/home/model/student_model.dart';
import 'package:yoyo_school_app/features/homework/model/home_model.dart';
import 'package:yoyo_school_app/features/profile/model/user_deatils_mode.dart';
import 'package:yoyo_school_app/features/profile/presentation/profile_provider.dart';
import 'package:yoyo_school_app/features/result/model/user_result_model.dart';

import '../../../config/router/navigation_helper.dart';
import '../../common/presentation/global_provider.dart';
import '../model/classes_model.dart';
import '../model/level_model.dart';
import '../model/school_model.dart';

class HomeScreenProvider extends ChangeNotifier {
  final HomeRepository homeRepository;
  List<Level>? levels = [];
  Student? userClases;
  Student? student;
  int totalPhrases = 0;
  int atemptedPhrases = 0;
  StreamSubscription<Student?>? _studentSubscription;
  ProfileProvider? profileProvider;
  GlobalProvider? globalProvider;
  School? school;
  List<HomeworkModel> homeWorkModel = [];
  List<UserDetailsModel> userDetailsModel = [];
  int homeworkDays = 0;

  int classPhrases = 0;
  int classVocab = 0;
  int classEffort = 0;
  int classScore = 0;
  int classCPhrases = 0;

  int schoolPhrase = 0;
  int schoolVocab = 0;
  int schoolEffort = 0;
  int schoolScore = 0;
  int schoolCPhrase = 0;

  int homeWorkScore = 0;
  int homeworkStudent = 0;
  int homeworkCompletedStudents = 0;

  HomeScreenProvider(this.homeRepository) {
    profileProvider = Provider.of<ProfileProvider>(ctx!, listen: false);
    profileProvider?.initialize();

    notifyListeners();
  }

  getDetails() async {
    userDetailsModel = await homeRepository.getDetails(
      userClases?.user?.studentClasses?.first.classes?.id ?? 0,
    );
    userDetailsModel = userDetailsModel
      ..sort((a, b) => a.classRank!.compareTo(b.classRank!));
    notifyListeners();
  }

  getHomeWork() async {
    List<PhraseModel> phrasesHomework = await homeRepository.getHomeworkPhrase(
      homeWorkModel.last.id,
    );
    List<int> phraseIds = [];
    for (var val in phrasesHomework) {
      phraseIds.add(val.id!);
    }
    List<UserResult> results = await homeRepository.getHomeWorkResults(
      phraseIds,
    );

    final Map<String, List<UserResult>> userMap = {};

    for (var result in results) {
      final userId = result.userId;

      if (userId == null) continue;
      getDetails();
      userMap.putIfAbsent(userId, () => []).add(result);
    }

    for (var entry in userMap.entries) {
      final userResults = entry.value;

      if (userResults.length == phraseIds.length) {
        homeworkCompletedStudents++;
      }
    }

    double totalScore = 0;
    int count = 0;

    for (var result in results) {
      if (result.score != null) {
        totalScore += result.score!;
        count++;
      }
    }

    homeWorkScore = (count > 0 ? totalScore / count : 0).round();
  }

  getMetrics() async {
    schoolPhrase = 0;
    schoolCPhrase = 0;
    schoolVocab = 0;
    schoolEffort = 0;
    schoolScore = 0;

    classPhrases = 0;
    classCPhrases = 0;
    classVocab = 0;
    classEffort = 0;
    classScore = 0;
    homeworkStudent = 0;

    List<int> schoolVocabList = [];
    List<int> schoolEffortList = [];
    List<int> schoolScoreList = [];

    List<int> classVocabList = [];
    List<int> classEffortList = [];
    List<int> classScoreList = [];

    homeWorkModel = await homeRepository.getHomeWorkModel(
      profileProvider?.school?.id ?? 0,
    );
    if (homeWorkModel.isNotEmpty) {
      await getHomeWork();
    }
    DateTime now = DateTime.now();
    DateTime dueDate = homeWorkModel.first.dueDate ?? DateTime.now();
    homeworkDays = now.difference(dueDate).inDays;

    school = await homeRepository.getSchoolData(
      profileProvider?.school?.id ?? 0,
    );

    for (Classes classes in school?.classes ?? []) {
      final disabledIds =
          globalProvider?.apiCred?.phraseDisabledSchools
              .map((e) => e.phraseId)
              .whereType<int>()
              .toSet() ??
          {};

      final phrases = classes.language?.phrase;

      if (classes.studentClasses?.isNotEmpty ?? false) {
        if (classes.id == userClases?.user?.studentClasses?.first.classes?.id) {
          homeworkStudent++;
          classVocabList.add(
            classes.studentClasses?.first.user?.student?.vocab ?? 0,
          );
          classEffortList.add(
            classes.studentClasses?.first.user?.student?.effort ?? 0,
          );
          classScoreList.add(
            classes.studentClasses?.first.user?.student?.score ?? 0,
          );

          classPhrases +=
              phrases
                  ?.where((phrase) => !disabledIds.contains(phrase.id))
                  .length ??
              0;

          List<int> langIds = [classes.language?.id ?? 0];

          classCPhrases +=
              classes.studentClasses?.firstOrNull?.user?.userResult
                  ?.where(
                    (element) =>
                        langIds.contains(element.phrase?.language) &&
                        element.scoreSubmitted == true,
                  )
                  .length ??
              0;
        }
        List<int> langIds = [classes.language?.id ?? 0];

        schoolCPhrase +=
            classes.studentClasses?.firstOrNull?.user?.userResult
                ?.where(
                  (element) =>
                      langIds.contains(element.phrase?.language) &&
                      element.scoreSubmitted == true,
                )
                .length ??
            0;
        schoolPhrase +=
            phrases
                ?.where((phrase) => !disabledIds.contains(phrase.id))
                .length ??
            0;
        schoolVocabList.add(
          classes.studentClasses?.first.user?.student?.vocab ?? 0,
        );
        schoolEffortList.add(
          classes.studentClasses?.first.user?.student?.effort ?? 0,
        );
        schoolScoreList.add(
          classes.studentClasses?.first.user?.student?.score ?? 0,
        );
      }
    }

    int safeAvg(List<int>? list) {
      if (list == null || list.isEmpty) return 0;

      return (list.reduce((a, b) => a + b) / list.length).toInt();
    }

    schoolVocab = safeAvg(schoolVocabList);
    schoolEffort = safeAvg(schoolEffortList);
    schoolScore = safeAvg(schoolScoreList);

    classVocab = safeAvg(classVocabList);
    classEffort = safeAvg(classEffortList);
    classScore = safeAvg(classScoreList);
  }

  Future<bool> init({bool home = true}) async {
    try {
      globalProvider = Provider.of<GlobalProvider>(ctx!, listen: false);
      userClases = await homeRepository.getClasses();
      if (userClases == null) {
        throw "Could not load classes";
      }

      levels = await homeRepository.getLevel();
      if (levels == null) {
        throw "Could not load levels";
      }

      totalPhrases = 0;
      userClases?.user?.studentClasses?.forEach((student) {
        totalPhrases += student.classes?.language?.phrase?.length ?? 0;
      });

      userClases
          ?.user
          ?.studentClasses
          ?.first
          .classes
          ?.language
          ?.phrase = await translateAll(
        userClases?.user?.studentClasses?.first.classes?.language?.phrase ?? [],
      );

      _subscribeToStudentData();
      getDetails();
      getMetrics();
      notifyListeners();
      if (userClases?.user?.studentClasses?.length == 1 && home) {
        NavigationHelper.go(
          RouteNames.phraseCategories,
          extra: {
            'language':
                userClases?.user?.studentClasses?.first.classes?.language,
            "className":
                userClases?.user?.studentClasses?.first.classes?.className,
            "level": levels,
            'student': userClases,
          },
        );
        return false;
      }
      return true;
    } catch (e) {
      throw Exception("Home initialization failed: $e");
    }
  }

  Future<List<PhraseModel>> translateAll(List<PhraseModel> phrases) async {
    return await Future.wait(
      phrases.map((p) async {
        await p.translate();
        return p;
      }),
    );
  }

  void _subscribeToStudentData() {
    try {
      _studentSubscription = homeRepository.getUserDataStream().listen(
        (studentdata) async {
          try {
            if (studentdata == null) return;
            student = studentdata;
            List<int> ids = [];
            for (StudentClassesModel studentClasses
                in userClases?.user?.studentClasses ?? []) {
              for (PhraseModel phrase
                  in studentClasses.classes?.language?.phrase ?? []) {
                ids.add(phrase.id ?? 0);
              }
            }
            List<int> langIds = [];
            userClases?.user?.studentClasses?.forEach(
              (val) => langIds.add(val.classes?.language?.id ?? 0),
            );
            atemptedPhrases =
                userClases?.user?.userResult
                    ?.where(
                      (element) =>
                          langIds.contains(element.phrase?.language) &&
                          element.scoreSubmitted == true,
                    )
                    .length ??
                0;
            notifyListeners();
          } catch (e) {
            throw Exception("Failed to update student data: $e");
          }
        },
        onError: (error) {
          debugPrint("Student stream error: $error");
          throw Exception("Student stream crashed: $error");
        },
      );
    } catch (e) {
      throw Exception("Failed to subscribe to student stream: $e");
    }
  }

  @override
  void dispose() {
    _studentSubscription?.cancel();
    super.dispose();
  }
}
