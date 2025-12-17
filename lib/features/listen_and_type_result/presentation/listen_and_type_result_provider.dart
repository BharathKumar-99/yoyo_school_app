import 'package:flutter/material.dart';

import '../../home/model/phrases_model.dart';

class ListenAndTypeResultProvider extends ChangeNotifier {
  PhraseModel model;
  String typedString;

  ListenAndTypeResultProvider(this.model, this.typedString) {
    init();
  }
  init() async {}
}
