


import 'package:hackernews_flutter/api/base_api.dart';
import 'package:hackernews_flutter/api/ids_topstories_services.dart';
import 'package:hackernews_flutter/api/item_service.dart';
import 'package:hackernews_flutter/model/story.dart';
import 'package:hackernews_flutter/repository/base_repository.dart';

class TopStoriesRepository extends BaseRepository with IdsServices{

  String url;

  final ItemService _service = ItemService();

  TopStoriesRepository({this.url});

  Future<Story> getFromServerTopStories() async {
    try {
      final result = await _service.fetchItem(url);

      if(result != null){
        return Story.fromJson(result);
      }
    } catch (e){
      throw Exception(e);
    }
  }

  @override
  String getUrl() {
    return url;
  }

  @override
  void setUrl(String setUrl) {
    url = setUrl;
  }
}