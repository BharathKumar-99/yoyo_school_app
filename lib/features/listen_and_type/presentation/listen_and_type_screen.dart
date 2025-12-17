import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/core/widgets/back_btn.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';
import 'package:yoyo_school_app/features/home/model/school_launguage.dart';
import 'package:yoyo_school_app/features/home/model/student_model.dart';
import 'package:yoyo_school_app/features/listen_and_type/presentation/listen_and_type_view_model.dart';

class ListenAndTypeScreen extends StatelessWidget {
  final PhraseModel model;
  final SchoolLanguage schoolLanguage;
  final String className;
  final Student student;
  final int categories;
  const ListenAndTypeScreen({
    super.key,
    required this.model,
    required this.schoolLanguage,
    required this.className,
    required this.student,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ListenAndTypeViewModel>(
      builder: (context, value, wi) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                  backBtn(
                    streak: false,
                    context: context,
                    slanguage: schoolLanguage,
                    className: className,
                    student: student,
                    categories: value.categories,
                  ),
                  Card(
                    elevation: 0,
                    color: value.language?.gradient?.first.withValues(
                      alpha: 0.4,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50),
                            splashColor:
                                value.language?.gradient?.first.withValues(
                                  alpha: 0.2,
                                ) ??
                                Colors.grey.withValues(alpha: 0.2),
                            onTap: () async => await value.playAudio(),
                            child: Center(
                              child: Icon(
                                Icons.play_arrow_outlined,
                                size: 45,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
