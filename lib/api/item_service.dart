


import 'package:dio/dio.dart';
import 'package:hackernews_flutter/api/base_api.dart';
import 'package:hackernews_flutter/utils/endpoints.dart';

class ItemService {
  
  Future<dynamic> fetchItem(String url) async {
    try {
      final Response result = await BaseApi.getData(url: url, queryParams: {'print' : 'pretty'});
      if(result != null) return result.data;
    } catch (e) {
      throw Exception(e);
    }
    return null;
  } 
}