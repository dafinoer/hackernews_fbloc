



import 'package:dio/dio.dart';
import 'package:hackernews_flutter/api/base_api.dart';
import 'package:hackernews_flutter/utils/endpoints.dart';

class IdsServices {

  Future<List<int>> fetchIds(String urlEndpoint) async {
    try {
      final Response resultFromJson = await BaseApi.getData(url: urlEndpoint);
      return List.from(resultFromJson.data);
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}