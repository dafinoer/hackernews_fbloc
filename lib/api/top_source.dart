import 'package:dio/src/dio.dart';
import 'package:hackernews_flutter/common/remote/base_remote.dart';
import 'package:hackernews_flutter/common/remote/config/result.dart';
import 'package:hackernews_flutter/model/story.dart';
import 'package:hackernews_flutter/utils/endpoints.dart';

class TopSource extends BaseRemote {
  TopSource(Dio dio) : super(dio);

  Future<Result<List<dynamic>>> fetchTopStory() async {
    const url = Endpoint.top_ids;
    final responeResult = await getMethod(url, converter: (respone) => List.from(respone));
    return responeResult;
  }

  Future<Result<Story>> fetchItem(int id) async {
    final url = Endpoint.ITEM.replaceAll('{id}', id.toString());
    final responseResult = await getMethod(url, converter: (respone) => Story.fromJson(respone));
    return responseResult;
  }
}
