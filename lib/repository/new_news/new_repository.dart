


import 'package:hackernews_flutter/model/story.dart';

abstract class NewRepository {
  Future<List<int>> getIds();
  Future<List<Story>> getStories(List<int> ids);
}