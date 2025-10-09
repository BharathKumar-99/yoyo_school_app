import 'package:flutter/material.dart';

import '../../home/model/school_launguage.dart';

class PhrasesViewModel extends ChangeNotifier {
  final SchoolLanguage classes;

  PhrasesViewModel(this.classes);
}
