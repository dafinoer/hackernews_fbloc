import 'package:dio/dio.dart';
import 'package:hackernews_flutter/api/top_source.dart';
import 'package:hackernews_flutter/common/remote/config/network_func.dart';
import 'package:hackernews_flutter/common/remote/config/result.dart';
import 'package:hackernews_flutter/model/story.dart';
import 'package:hackernews_flutter/repository/home/home_repository.dart';

class TopRepositoryImp extends TopRepository {
  TopSource _topSource;

  TopRepositoryImp(this._topSource);

  @override
  Future<void> getTopApi(Function(List<Story> listId) onSucess,
      Function(String text, List<Story> listId) onError) async {
    final responseItem = await _topSource.fetchTopStory();
    responseHandler(responseItem, onSuccess: (success) {
      final items =
          List.from(responseItem.body.map((e) => Story.fromJson(e)).toList());
      onSucess(items);
    }, onError: (dioerror, code, errorbody) {
      onError(errorbody, []);
    });
  }

  @override
  Future<List<int>> getTopIds() async {
    final responseItem = await _topSource.fetchTopStory();
    switch (responseItem.status) {
      case Status.succes:
        final items = List<int>.from(responseItem.body.map((e) => e).toList());
        return items;
        break;
      case Status.error:
        throw Exception('code : ${responseItem?.code} --> ${responseItem?.errorBody} --> dio : ${responseItem?.dioError}');
        // throw Exception('error : ${responseItem.code}');
        // print(responseItem.code ?? 'none');
        break;
      default:
        throw ArgumentError();
    }
  }
}
