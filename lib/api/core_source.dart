import 'package:dio/src/dio.dart';
import 'package:hackernews_flutter/common/remote/base_remote.dart';
import 'package:hackernews_flutter/common/remote/config/result.dart';
import 'package:hackernews_flutter/model/story.dart';
import 'package:hackernews_flutter/utils/endpoints.dart';

class BaseSource extends BaseRemote {
  BaseSource(Dio dio) : super(dio);

  Future<Result<List<dynamic>>> fetchIds(String urls) async {
    final responeResult = await getMethod(urls, converter: (respone) => List.from(respone));
    return responeResult;
  }

  Future<Result<dynamic>> fetchItem(String urlparams) async {
    final url = Endpoint.ITEM.replaceAll('{id}', urlparams);
    final responseResult = await getMethod(url, converter: (respone) => Story.fromJson(respone));
    return responseResult;
  }
  
}