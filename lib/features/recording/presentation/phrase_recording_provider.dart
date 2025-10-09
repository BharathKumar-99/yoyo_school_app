import 'package:flutter/material.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';

class PhraseRecordingProvider extends ChangeNotifier {
  PhraseModel phraseModel;
  bool showPhrase = true;

  PhraseRecordingProvider(this.phraseModel);

  togglePhrase() {
    showPhrase = !showPhrase;
    notifyListeners();
  }

  showReadBottomPopup(BuildContext context) => showModalBottomSheet(
    context: context,
    builder: (_) => SizedBox(
      height: MediaQuery.sizeOf(context).height / 2,
      width: double.infinity,
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.mic_none_rounded),
            ),
          ),
          Text(text.readAndpractise),
        ],
      ),
    ),
  );
}
