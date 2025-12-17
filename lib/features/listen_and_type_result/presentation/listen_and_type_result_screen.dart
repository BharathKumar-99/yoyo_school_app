import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';
import 'package:yoyo_school_app/features/listen_and_type_result/presentation/listen_and_type_result_provider.dart';

class ListenAndTypeResultScreen extends StatelessWidget {
  final PhraseModel model;
  final String typedString;
  const ListenAndTypeResultScreen({
    super.key,
    required this.model,
    required this.typedString,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ListenAndTypeResultProvider>(
      create: (_) => ListenAndTypeResultProvider(model, typedString),
      child: Consumer<ListenAndTypeResultProvider>(
        builder: (context, value, child) => Scaffold(),
      ),
    );
  }
}
