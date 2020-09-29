import 'package:hackernews_flutter/api/item_service.dart';
import 'package:hackernews_flutter/model/story.dart';

class StoriesRepository {
  String url;

  final ItemService _service = ItemService();

  StoriesRepository({this.url});

  Future<Story> fetchStories() async {
    try {
      final result = await _service.fetchItem(url);

      if(result != null){
        return Story.fromJson(result);
      }
    } catch (e){
      throw Exception(e);
    }
  }

}