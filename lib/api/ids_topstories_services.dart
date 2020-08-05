



import 'package:dio/dio.dart';
import 'package:hackernews_flutter/api/base_api.dart';
import 'package:hackernews_flutter/utils/endpoints.dart';

class IdsServices {

  Future<List<int>> idsTopStories() async {
    try {
      final Response resultFromJson = await BaseApi.getData(url: Endpoint.top_stories_ids);
      return List.from(resultFromJson.data);
    } catch (e) {
      throw Exception(e);
    }
  }
}