import 'package:hackernews_flutter/api/base_api.dart';
import 'package:hackernews_flutter/api/ids_topstories_services.dart';
import 'package:hackernews_flutter/api/item_service.dart';
import 'package:hackernews_flutter/model/story.dart';
import 'package:hackernews_flutter/repository/base_repository.dart';
import 'package:hackernews_flutter/repository/stories_repository.dart';

class TopStoriesRepository extends StoriesRepository
    with IdsServices
    implements BaseRepository {
  @override
  String getUrl() {
    return url;
  }

  @override
  void setUrl(String setUrl) {
    url = setUrl;
  }

  // String _url;

  // final ItemService _service = ItemService();

  // Future<Story> getFromServerTopStories() async {
  //   try {
  //     final result = await _service.fetchItem(_url);

  //     if(result != null){
  //       return Story.fromJson(result);
  //     }
  //   } catch (e){
  //     throw Exception(e);
  //   }
  // }

  // @override
  // String getUrl() {
  //   return _url;
  // }

  // @override
  // void setUrl(String setUrl) {
  //   _url = setUrl;
  // }
}
