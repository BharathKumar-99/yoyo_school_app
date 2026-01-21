import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/core/widgets/back_btn.dart';
import 'package:yoyo_school_app/features/home/model/language_model.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';
import 'package:yoyo_school_app/features/home/model/student_model.dart';
import 'package:yoyo_school_app/features/listen_and_type/presentation/listen_and_type_view_model.dart';

import 'widgets/fake_wave.dart';

class ListenAndTypeScreen extends StatelessWidget {
  final PhraseModel model;
  final Language language;
  final String className;
  final Student student;
  final int categories;
  const ListenAndTypeScreen({
    super.key,
    required this.model,
    required this.language,
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
            resizeToAvoidBottomInset: true,

            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    backBtn(
                      streak: false,
                      context: context,
                      slanguage: language,
                      className: className,
                      student: student,
                      categories: value.categories,
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: value.playAudio,
                        child: Card(
                          elevation: 0,
                          color: value.language?.gradient?.first.withValues(
                            alpha: 0.4,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(20),
                            child: Icon(
                              Icons.play_arrow_outlined,
                              size: 45,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
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

                    const SizedBox(height: 20),

                    AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
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
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextField(
                          controller: value.textEditingController,
                          maxLines: 10,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: text.listenTextField,
                          ),
                        ),
                      ),
                    ),

                    // 👇 space so content doesn't hide behind button
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),

            bottomNavigationBar: SafeArea(
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.only(
                  left: 28,
                  right: 28,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: value.language?.gradient?.first,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: value.submit,
                    child: const Text('Submit'),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
