import 'package:flutter/material.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';

class PhraseRecordingProvider extends ChangeNotifier {
  PhraseModel phraseModel;

  PhraseRecordingProvider(this.phraseModel);
}
