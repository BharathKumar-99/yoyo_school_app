import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/core/widgets/back_btn.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';
import 'package:yoyo_school_app/features/master_phrase/presentation/master_phrase_provider.dart';
import 'package:yoyo_school_app/features/recording/presentation/remember_and_practise_screen.dart';

class MasterPhraseSreen extends StatelessWidget {
  final PhraseModel model;

  const MasterPhraseSreen({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;

    double w(double factor) => width * factor;
    double h(double factor) => height * factor;
    return ChangeNotifierProvider<MasterPhraseProvider>(
      create: (_) => MasterPhraseProvider(model),
      child: Consumer<MasterPhraseProvider>(
        builder: (context, value, child) => Scaffold(
          body: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: value.language?.gradient ?? [],
                begin: AlignmentGeometry.topLeft,
                end: AlignmentGeometry.bottomRight,
              ),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(70),
                  spreadRadius: 5,
                  blurRadius: 4,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: h(0.03)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: w(0.07)),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: backBtn(),
                    ),
                  ),
                  SizedBox(height: h(0.05)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 29.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.translate_rounded),
                        ),
                        Expanded(
                          child: Text(value.phraseModel.translation ?? ''),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            value.language?.image ?? "",
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: value.language != null
              ? RememberAndPractiseScreen(
                  model: model,
                  launguage: value.language!,
                )
              : Container(),
        ),
      ),
    );
  }
}
