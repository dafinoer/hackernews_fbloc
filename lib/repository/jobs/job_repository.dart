

import 'package:hackernews_flutter/model/job.dart';

abstract class JobRepository {
  Future<List<int>> getIds();
  Future<List<Job>> getStories(List<int> params);
}