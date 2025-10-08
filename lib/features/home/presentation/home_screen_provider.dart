import 'package:flutter/material.dart';
import 'package:yoyo_school_app/features/home/data/home_repository.dart';
import 'package:yoyo_school_app/features/home/model/student_model.dart';

class HomeScreenProvider extends ChangeNotifier {
  final HomeRepository homeRepository;
  Student? userClases;
  HomeScreenProvider(this.homeRepository) {
    init();
  }

  init() async {
  userClases = await homeRepository.getClasses();
    notifyListeners();
  }
}
