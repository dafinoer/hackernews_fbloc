



import 'package:dio/dio.dart';
import 'package:hackernews_flutter/api/base_api.dart';

class IdsServices {

  Future<List<int>> fetchIds(String urlEndpoint) async {
    try {
      final Response resultFromJson = await BaseApi.getData(url: urlEndpoint);
      return Future.value(List.from(resultFromJson.data));
    } catch (e) {
      throw Exception(e);
    }
  }
}