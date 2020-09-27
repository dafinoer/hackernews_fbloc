import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hackernews_flutter/api/item_service.dart';
import 'package:hackernews_flutter/model/comment.dart';

class CommentRepository {
  final ItemService _itemService = ItemService();

  Future<Comment> fetchComment(String url) async {
    try {
      final resultJson = await _itemService.fetchItem(url);
      return Comment.fromJson(resultJson);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Comment>> quequeAsync(List<String> params) async {
    try {
      final results = await Future.wait(params.map((e) => fetchComment(e)).toList());
      return results;
    } catch (e) {
      throw Exception(e);
    }
  }  
}
