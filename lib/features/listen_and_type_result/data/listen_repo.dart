import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:yoyo_school_app/features/listen_and_type_result/model/listen_model.dart';

class ListenRepo {
  Future<ListenModel> getTextResult(String typed, String phraseModel) async {
    final url = Uri.parse(
      'https://xijaobuybkpfmyxcrobo.supabase.co/functions/v1/evaluate_listening',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'original': phraseModel, 'student': typed}),
    );

    if (response.statusCode != 200) {
      throw Exception('Edge function failed');
    }

    return ListenModel.fromJson(jsonDecode(response.body));
  }
}
