

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:hackernews_flutter/common/remote/config/logging_interceptor.dart';
import 'package:hackernews_flutter/utils/endpoints.dart';

class DioModule with DioMixin implements Dio{

  DioModule._([BaseOptions options]){
    options = BaseOptions(
      baseUrl: Endpoint.BASE_URL,
      contentType: 'application/json',
      connectTimeout: 3000,
      sendTimeout: 3000,
      receiveTimeout: 3000
    );

    this.options = options;
    interceptors.add(LoggingInterceptor());
    httpClientAdapter = DefaultHttpClientAdapter();
  }

  static Dio getInstance() => DioModule._();
}