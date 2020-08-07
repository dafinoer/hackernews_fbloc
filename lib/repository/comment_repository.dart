

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hackernews_flutter/api/item_service.dart';
import 'package:hackernews_flutter/model/comment.dart';
import 'package:hackernews_flutter/repository/base_repository.dart';

class CommentRepository extends BaseRepository {

  String _url;

  final ItemService _itemService = ItemService();

  Future<Comment> fetchComment() async {
    try {
      final resultJson = await _itemService.fetchItem(_url, options: Options(
        method: 'GET',
        responseType: ResponseType.bytes
      ));
      var dataByte = utf8.decode(resultJson);
      var decodeJson = json.decode(dataByte);
      return Comment.fromJson(decodeJson);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  String getUrl() {
    return _url;
  }

  @override
  void setUrl(String setUrl) {
    this._url = setUrl;
  }

}