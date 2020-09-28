import 'package:hackernews_flutter/model/story.dart';

abstract class TopRepository {
  Future<void> getTopApi(Function(List<Story> listId) onSucess,
      Function(String message, List<Story> listId) onError);
  Future<List<int>> getTopIds();
  Future<List<Story>> getStories(List<int> params);
}
