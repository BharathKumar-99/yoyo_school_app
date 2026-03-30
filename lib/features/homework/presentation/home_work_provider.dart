import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/config/utils/global_loader.dart';
import 'package:yoyo_school_app/config/utils/popup_global.dart';
import 'package:yoyo_school_app/features/home/presentation/home_screen_provider.dart';

class HomeWorkProvider extends ChangeNotifier {
  List<String> selectedStructure = [];
  List<String> selectedSubject = [];
  DateTime? selectedDate;
  HomeScreenProvider? homeScreenProvider;
  TextEditingController anythingElseController = TextEditingController();
  bool isLoading = false;
  final List<String> structures = [
    text.conversation,
    text.presentTense,
    text.pastTense,
    text.futureTense,
    text.opinions,
    text.reasons,
    text.descriptions,
    text.questions,
    text.negatives,
    text.comparisons,
  ];

  final List<String> subjects = [
    text.myself,
    text.family,
    text.friends,
    text.school,
    text.home,
    text.freeTime,
    text.hobbies,
    text.foodAndDrink,
    text.holidays,
    text.townLocalArea,
  ];

  HomeWorkProvider(BuildContext context) {
    homeScreenProvider = Provider.of<HomeScreenProvider>(
      context,
      listen: false,
    );
  }

  void selectStructure(String text) {
    if (selectedStructure.contains(text)) {
      selectedStructure.clear(); // deselect if same tapped
    } else {
      selectedStructure
        ..clear()
        ..add(text); // keep only one
    }
    notifyListeners();
  }

  void selectSubject(String text) {
    if (selectedSubject.contains(text)) {
      selectedSubject.remove(text);
    } else {
      if (selectedSubject.length >= 2) {
        selectedSubject.removeAt(0); // remove oldest
      }
      selectedSubject.add(text);
    }
    notifyListeners();
  }

  void pickDate(DateTime pickedDate) {
    selectedDate = pickedDate;
    notifyListeners();
  }

  Future<void> createHomework(BuildContext context) async {
    try {
      if (selectedDate == null) {
        throw "Select due date";
      }

      isLoading = true;
      notifyListeners();

      final int schoolId = homeScreenProvider?.profileProvider?.school?.id ?? 0;
      final int classId =
          homeScreenProvider
              ?.userClases
              ?.user
              ?.studentClasses
              ?.first
              .classes
              ?.id ??
          0;
      final int languageId =
          homeScreenProvider
              ?.userClases
              ?.user
              ?.studentClasses
              ?.first
              .classes
              ?.language
              ?.id ??
          0;

      // ✅ 2. Prepare Request
      final url = Uri.parse(
        'https://xijaobuybkpfmyxcrobo.supabase.co/functions/v1/add_homework',
      );

      final body = {
        "due_date": selectedDate!.toIso8601String(),
        "structures": selectedStructure,
        "subjects": selectedSubject,
        "anythingelse": anythingElseController.text.trim(),
        "schoolId": schoolId,
        "classId": classId,
        "phraseCount": 10,
        "languageId": languageId,
      };

      // ✅ 3. API Call
      final response = await http.post(url, body: jsonEncode(body));

      final data = jsonDecode(response.body);

      if (response.statusCode != 200 || data['success'] != true) {
        throw data['error'] ?? "Failed to create homework";
      }

      isLoading = false;
      notifyListeners();
      PopupDialog.show(selectedDate!);
      context.go(RouteNames.home);
    } catch (e) {
      GlobalLoader.hide();
      debugPrint("Error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }
}
