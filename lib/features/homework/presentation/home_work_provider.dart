import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/utils/global_loader.dart';
import 'package:yoyo_school_app/features/home/presentation/home_screen_provider.dart';

class HomeWorkProvider extends ChangeNotifier {
  List<String> selectedStructure = [];
  List<String> selectedSubject = [];
  DateTime? selectedDate;
  HomeScreenProvider? homeScreenProvider;
  TextEditingController anythingElseController = TextEditingController();

  final List<String> structures = [
    text.conversation,
    text.pastTense,
    text.presentTense,
    text.opinions,
    text.negatives,
  ];

  final List<String> subjects = [
    text.holidays,
    text.school,
    text.foodAndDrink,
    text.myself,
    text.friends,
  ];

  HomeWorkProvider(BuildContext context) {
    homeScreenProvider = Provider.of<HomeScreenProvider>(
      context,
      listen: false,
    );
  }

  void selectStructure(String text) {
    if (selectedStructure.contains(text)) {
      selectedStructure.removeWhere((val) => val == text);
    } else {
      selectedStructure.add(text);
    }
    notifyListeners();
  }

  void selectSubject(String text) {
    if (selectedSubject.contains(text)) {
      selectedSubject.removeWhere((val) => val == text);
    } else {
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

      GlobalLoader.show();

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

      // ✅ 4. Success Handling
      final homeworkId = data['homework_id'];
      final title = data['title'];
      final phraseIds = data['phrase_ids'];
      GlobalLoader.hide();
      showAdaptiveDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog.adaptive(
          title: Text('Building'),
          content: SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
      );
    } catch (e) {
      GlobalLoader.hide();
      debugPrint("Error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }
}
