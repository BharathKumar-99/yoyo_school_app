import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/theme/app_text_styles.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';
import 'package:yoyo_school_app/features/listen_and_type_result/presentation/listen_and_type_result_provider.dart';

import '../../home/model/language_model.dart';

class ListenAndTypeResultScreen extends StatelessWidget {
  final PhraseModel model;
  final String typedString;
  final Language language;
  const ListenAndTypeResultScreen({
    super.key,
    required this.model,
    required this.typedString,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    double h(double factor) => height * factor;
    double w(double factor) => width * factor;
    return ChangeNotifierProvider<ListenAndTypeResultProvider>(
      create: (_) => ListenAndTypeResultProvider(model, typedString, language),
      child: Consumer<ListenAndTypeResultProvider>(
        builder: (context, value, child) => Scaffold(
          body: value.loading
              ? Container(
                  height: MediaQuery.sizeOf(context).height,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    color: language.gradient?.first ?? Colors.white,
                  ),
                  child: Center(
                    child: SizedBox(
                      height: 200,
                      child: Lottie.asset(
                        AnimationAsset.yoyoWaitingText,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                )
              : Column(
                  children: [
                    Container(
                      height: h(0.6),

                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: language.gradient ?? [],
                        ),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            value.language.image ?? '',
                          ),
                          fit: BoxFit.fill,
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
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: w(0.07)),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: IconButton(
                                      onPressed: () async {
                                        NavigationHelper.pop();
                                      },
                                      icon: const Icon(
                                        Icons.arrow_back_ios_new,
                                        size: 20,
                                        color: Colors.black,
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                              Colors.transparent,
                                            ),
                                        shape: WidgetStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            side: const BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        fixedSize: WidgetStateProperty.all(
                                          const Size(40, 40),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    child: Center(
                                      child: CircleAvatar(
                                        backgroundColor: language
                                            .gradient
                                            ?.first
                                            .withValues(alpha: 0.7),
                                        radius: 60,
                                        child: Text(
                                          '${value.listenModel?.overallScore?.toString()} %',
                                          style: AppTextStyles
                                              .textTheme
                                              .headlineLarge!
                                              .copyWith(
                                                color: Colors.white,
                                                fontSize: w(0.12),
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(),
                                ],
                              ),
                              Spacer(),
                              Container(
                                width: width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 10,
                                    children: [
                                      Text('Target:'),
                                      Text(
                                        model.phrase ?? '',
                                        style:
                                            AppTextStyles.textTheme.titleLarge,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Spacer(),
                              Container(
                                width: width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 10,
                                    children: [
                                      Text('Your submission:'),
                                      SizedBox(
                                        width: double.infinity,
                                        height: h(0.08),
                                        child: LayoutBuilder(
                                          builder: (context, constraints) {
                                            final entries = value
                                                .listenModel!
                                                .words!
                                                .entries
                                                .toList();

                                            final spans = entries.map((entry) {
                                              final word = entry.key;
                                              final scoreOrColorValue =
                                                  entry.value;

                                              return TextSpan(
                                                text: '$word ',
                                                style: TextStyle(
                                                  color: value.getWordColor(
                                                    scoreOrColorValue,
                                                  ),
                                                ),
                                              );
                                            }).toList();

                                            final fontSize = value.fitFontSize(
                                              spans: spans,
                                              maxWidth: constraints.maxWidth,
                                              maxHeight: constraints.maxHeight,
                                            );

                                            return RichText(
                                              softWrap: true,
                                              overflow: TextOverflow.fade,
                                              text: TextSpan(
                                                children: spans.map((span) {
                                                  return TextSpan(
                                                    text: span.text,
                                                    style: span.style?.copyWith(
                                                      fontSize: fontSize,
                                                      height: 1.3,
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28.0),
                      child: Column(
                        spacing: 20,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          AutoSizeText(
                            value.listenModel?.title ?? '',
                            maxLines: 1,
                            style: AppTextStyles.textTheme.headlineLarge,
                          ),

                          Column(
                            children: [
                              Row(
                                children: [
                                  Text('Accuracy: '),
                                  Text(
                                    '${value.listenModel?.wordAccuracy}%',
                                    style: AppTextStyles.textTheme.titleLarge,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Phonics: '),
                                  Text(
                                    '${value.listenModel?.phoneticAccuracy}%',
                                    style: AppTextStyles.textTheme.titleLarge,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Grammer: '),
                                  Text(
                                    '${value.listenModel?.grammarEndings}%',
                                    style: AppTextStyles.textTheme.titleLarge,
                                  ),
                                ],
                              ),
                            ],
                          ),

                          AutoSizeText(
                            value.listenModel?.body ?? '',
                            maxLines: 3,
                          ),

                          SizedBox(
                            width: width,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: language.gradient!.first,
                              ),
                              onPressed: () {
                                NavigationHelper.pop();
                              },
                              child: Text(text.tryAgain),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
