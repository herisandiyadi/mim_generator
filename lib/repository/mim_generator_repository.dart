import 'dart:convert';

import 'package:algo_test/model/mim_model.dart';
import 'package:http/http.dart' as http;

abstract class MimGeneratorRepositoryImpl {
  Future<MimModel> getMim();
}

class MimGeneratorRepository implements MimGeneratorRepositoryImpl {
  @override
  Future<MimModel> getMim() async {
    final url = Uri.parse('https://api.imgflip.com/get_memes');
    final response = await http.get(url);
    final json = jsonDecode(response.body);
    print(json);
    if (response.statusCode == 200) {
      final jsonResult = MimModel.fromJson(json);
      return jsonResult;
    }
    throw Exception('Failed to load data');
  }
}
