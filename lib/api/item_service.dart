


import 'package:dio/dio.dart';
import 'package:hackernews_flutter/api/base_api.dart';
import 'package:hackernews_flutter/utils/endpoints.dart';
import 'dart:convert';

class ItemService {
  
  Future<dynamic> fetchItem(String url, {Options options}) async {
    try {
      final Response result = await BaseApi.getData(url: url, queryParams: {'print' : 'pretty'}, options: options);
      if(result != null) return result.data;
    } catch (e) {
      throw Exception(e);
    }
    return null;
  } 
}