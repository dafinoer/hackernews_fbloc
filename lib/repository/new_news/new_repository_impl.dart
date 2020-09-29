import 'dart:collection';

import 'package:hackernews_flutter/api/core_source.dart';
import 'package:hackernews_flutter/common/remote/config/result.dart';
import 'package:hackernews_flutter/model/story.dart';
import 'package:hackernews_flutter/repository/new_news/new_repository.dart';
import 'package:hackernews_flutter/utils/endpoints.dart';

class NewRepositoryImpl extends NewRepository {
  BaseSource _source;

  NewRepositoryImpl(this._source);

  @override
  Future<List<int>> getIds() async {
    const urls = Endpoint.NEWS_IDS;
    final itemResult = await _source.fetchIds(urls);

    switch (itemResult.status) {
      case Status.succes:
        final items = List<int>.from(itemResult.body.map((e) => e).toList());
        return items.toList();
        break;

      case Status.error:
        throw Exception(
            'code : ${itemResult?.code} --> ${itemResult?.errorBody} --> dio : ${itemResult?.dioError}');
        break;
      default:
        throw ArgumentError();
    }
  }

  @override
  Future<List<Story>> getStories(List<int> ids) async {
      final items = ids.map((e) => _source.fetchItem(e.toString())).toList();
      final results = await Future.wait(items, eagerError: true);
      return List<Story>.from(results.map((e) => e.body).toList());
  }
}
