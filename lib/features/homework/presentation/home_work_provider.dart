import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/config/utils/global_loader.dart';
import 'package:yoyo_school_app/config/utils/popup_global.dart';
import 'package:yoyo_school_app/features/home/presentation/home_screen_provider.dart';

import '../../../core/supabase/supabase_client.dart';

class HomeWorkProvider extends ChangeNotifier {
  List<String> selectedStructure = [];
  List<String> selectedSubject = [];
  DateTime? selectedDate;
  HomeScreenProvider? homeScreenProvider;
  TextEditingController anythingElseController = TextEditingController();
  bool isLoading = false;
  final SpeechToText speechToText = SpeechToText();
  bool _speechEnabled = false;

  int selectedAttachmentType = 0; // 0 = none, 1 = docs, 2 = photo
  bool exactContent = false;
  Uint8List? attachedBytes;
  String? attachedFileName;

  void setAttachmentType(int type) async {
    if (selectedAttachmentType == type) {
      selectedAttachmentType = 0; // toggle off
      attachedBytes = null;
      attachedFileName = null;
      notifyListeners();
      return;
    }

    if (type == 1) {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'png', 'jpg', 'jpeg'],
        withData: true,
      );
      if (result != null && result.files.isNotEmpty) {
        attachedBytes = result.files.first.bytes;
        attachedFileName = result.files.first.name;
        selectedAttachmentType = type;
      } else {
        selectedAttachmentType = 0;
        attachedBytes = null;
        attachedFileName = null;
      }
    } else if (type == 2) {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        attachedBytes = await image.readAsBytes();
        attachedFileName = image.name;
        selectedAttachmentType = type;
      } else {
        selectedAttachmentType = 0;
        attachedBytes = null;
        attachedFileName = null;
      }
    }
    notifyListeners();
  }

  void toggleExactContent(bool? value) {
    exactContent = value ?? false;
    notifyListeners();
  }

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
    initSpeech();
  }

  Future<void> initSpeech() async {
    _speechEnabled = await speechToText.initialize(
      onStatus: (status) => print('Status: $status'),
      onError: (error) => print('Error: $error'),
    );
    print("Speech available: $_speechEnabled");
    notifyListeners();
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

  void startListening() async {
    await speechToText.listen(onResult: _onSpeechResult);
    notifyListeners();
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void stopListening() async {
    await speechToText.stop();
    notifyListeners();
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    anythingElseController.text = result.recognizedWords;
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
      String publicUrl = '';
      if (attachedBytes != null && attachedFileName != null) {
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_$attachedFileName';

        final String uploadPath = 'homework/$classId/$fileName';
        await SupabaseClientService.instance.client.storage
            .from('homework')
            .uploadBinary(uploadPath, attachedBytes!);
        publicUrl = SupabaseClientService.instance.client.storage
            .from('homework')
            .getPublicUrl(uploadPath);
      }
      final url = Uri.parse(
        'https://xijaobuybkpfmyxcrobo.supabase.co/functions/v1/auto-homework',
      );

      final body = {
        "class_id": classId,
        "school_id": schoolId,
        "homework_prompt": anythingElseController.text.trim(),
        "homework_document": publicUrl,
      };

      final response = await http.post(url, body: jsonEncode(body));
      final data = jsonDecode(response.body);

      await Future.delayed(const Duration(seconds: 15));
      Timer.periodic(const Duration(minutes: 5), (timer) async {
        await homeScreenProvider?.init(home: false);
      });

      isLoading = false;
      notifyListeners();

      PopupDialog.show(
        selectedDate ?? DateTime.now().add(const Duration(days: 7)),
        homeScreenProvider
            ?.userClases
            ?.user
            ?.studentClasses
            ?.first
            .classes
            ?.language,
        homeScreenProvider?.levels ?? [],
        homeScreenProvider?.student,
        data['homework_id'],
        data['title'],
      );

      if (!context.mounted) return;
      context.go(RouteNames.home);
    } catch (e) {
      GlobalLoader.hide();
      debugPrint("Error: $e");

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }
}
