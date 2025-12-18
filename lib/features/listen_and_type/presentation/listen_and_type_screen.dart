import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/core/widgets/back_btn.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';
import 'package:yoyo_school_app/features/home/model/school_launguage.dart';
import 'package:yoyo_school_app/features/home/model/student_model.dart';
import 'package:yoyo_school_app/features/listen_and_type/presentation/listen_and_type_view_model.dart';

import 'widgets/fake_wave.dart';

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
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
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
                              onTap: () async => value.playAudio(),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28.0),
                      child: Column(
                        spacing: 10,
                        children: [
                          FakeWaveform(
                            isPlaying: value.isPlaying,
                            height: 30,
                            color: Colors.black,
                          ),

                          Text(text.listenPhrase),
                        ],
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      padding: EdgeInsets.only(top: 10),
                      curve: Curves.easeInOut,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color:
                              value.language?.gradient?.first.withValues(
                                alpha: 0.4,
                              ) ??
                              Colors.white,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                (value.language?.gradient?.first ??
                                        Colors.black)
                                    .withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          maxLines: 10,
                          controller: value.textEditingController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: text.listenTextField,
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: value.language?.gradient?.first,
                        ),
                        onPressed: () {
                          value.submit();
                        },
                        child: Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
