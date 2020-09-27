import 'package:dio/dio.dart';
import 'package:hackernews_flutter/common/remote/config/network_func.dart';
import 'package:hackernews_flutter/common/remote/config/result.dart';

abstract class BaseRemote {
  final Dio _dio;
  BaseRemote(this._dio);

  Future<Result<T>> getMethod<T>(String endpoint,
      {Map<String, String> header, ResponseConverter<T> converter}) async {
    Options opsi = Options(headers: header);
    final response = await callApi(_dio.get(endpoint, options: opsi), converter);
    return response;
  }

  // Future<dynamic> postMethod();

  // Future<dynamic> putMethod();

  // Future<dynamic> deleteMethod();
}
