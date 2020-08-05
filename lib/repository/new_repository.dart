import 'package:hackernews_flutter/api/ids_topstories_services.dart';
import 'package:hackernews_flutter/model/story.dart';
import 'package:hackernews_flutter/repository/base_repository.dart';
import 'package:hackernews_flutter/repository/stories_repository.dart';
import 'package:hackernews_flutter/repository/topstories_repository.dart';

class NewRepository extends StoriesRepository
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
}
