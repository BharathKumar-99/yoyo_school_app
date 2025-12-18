import 'package:flutter/material.dart';
import 'package:yoyo_school_app/features/listen_and_type_result/data/listen_repo.dart';
import 'package:yoyo_school_app/features/listen_and_type_result/model/listen_model.dart';

import '../../home/model/language_model.dart';
import '../../home/model/phrases_model.dart';

class TaggedWord {
  final String word;
  final Color color;

  TaggedWord(this.word, this.color);
}

class ListenAndTypeResultProvider extends ChangeNotifier {
  PhraseModel model;
  String typedString;
  final ListenRepo _repo = ListenRepo();
  ListenModel? listenModel;
  Language language;
  bool loading = true;
  ListenAndTypeResultProvider(this.model, this.typedString, this.language) {
    init();
  }
  init() async {
    listenModel = await _repo.getTextResult(typedString, model.phrase ?? '');
    loading = false;
    notifyListeners();
  }

  Color getWordColor(String score) {
    if (score == 'red') return Colors.red;
    if (score == 'green') return Colors.green;
    return Colors.red;
  }

  List<TaggedWord> parseTaggedSentence(String input) {
    final regex = RegExp(r'<(g|r|x)>(.*?)<\/\1>');
    final matches = regex.allMatches(input);

    return matches.map((match) {
      final tag = match.group(1);
      final word = match.group(2) ?? '';

      Color color;
      switch (tag) {
        case 'g':
          color = Colors.green;
          break;
        case 'r':
          color = Colors.red;
          break;
        case 'x':
          color = Colors.grey;
          break;
        default:
          color = Colors.black;
      }

      return TaggedWord(word, color);
    }).toList();
  }

  double fitFontSize({
    required List<TextSpan> spans,
    required double maxWidth,
    required double maxHeight,
    double maxFontSize = 40,
    double minFontSize = 6,
  }) {
    double fontSize = maxFontSize;

    while (fontSize >= minFontSize) {
      final painter = TextPainter(
        text: TextSpan(
          children: spans.map((s) {
            return TextSpan(
              text: s.text,
              style: s.style?.copyWith(fontSize: fontSize, height: 1.3),
            );
          }).toList(),
        ),
        textDirection: TextDirection.ltr,
      );

      painter.layout(maxWidth: maxWidth);

      if (painter.height <= maxHeight) {
        return fontSize; // ✅ fits
      }

      fontSize -= 1;
    }

    return minFontSize;
  }
}
