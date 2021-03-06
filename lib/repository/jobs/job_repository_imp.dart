import 'package:hackernews_flutter/api/core_source.dart';
import 'package:hackernews_flutter/common/remote/config/result.dart';
import 'package:hackernews_flutter/model/job.dart';
import 'package:hackernews_flutter/model/story.dart';
import 'package:hackernews_flutter/repository/jobs/job_repository.dart';
import 'package:hackernews_flutter/utils/endpoints.dart';

class JobRepositoryImpl extends JobRepository {
  BaseSource _source;

  JobRepositoryImpl(this._source);

  @override
  Future<List<int>> getIds() async {
    const urls = Endpoint.JOBS;
    final items = await _source.fetchIds(urls);

    switch (items.status) {
      case Status.succes:
        final result = List<int>.from(items.body.map((e) => e).toList());
        return result;
        break;
      case Status.error:
        throw Exception(
            'code : ${items?.code} --> ${items?.errorBody} --> dio : ${items?.dioError}');
        break;
      default:
        throw ArgumentError();
    }
  }

  @override
  Future<List<Job>> getStories(List<int> params) async {
    final items = params.map((e) async {
      final items = await _source.fetchItem(e.toString());
      switch (items.status) {
        case Status.succes:
          return items;
          break;
        case Status.error:
          throw Exception(
              'code : ${items?.code} --> ${items?.errorBody} --> dio : ${items?.dioError}');
          break;
        default:
      }
    }).toList();
    final result = await Future.wait(items, eagerError: true);
    final responseItems =
        List<Job>.from(result.map((e) => Job.fromJson(e.body)).toList());
    return responseItems;
  }
}
