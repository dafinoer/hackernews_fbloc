import 'dart:async';

import 'package:dio/dio.dart';
import 'package:hackernews_flutter/utils/logger_config.dart';

class LoggingInterceptor extends Interceptor {
  @override
  Future<FutureOr> onRequest(RequestOptions options) async{
    LoggerConfig.log.d("Headers");
    options.headers
        .forEach((key, value) => LoggerConfig.log.i('k:$key v:$value'));

    if(options.queryParameters != null){
      LoggerConfig.log.d("queryparams");
      options.queryParameters
          .forEach((key, value) => LoggerConfig.log.i('k:$key v:$value'));
    }

    if (options.data != null) {
      LoggerConfig.log.d("data");
      options.data
          .forEach((key, value) => LoggerConfig.log.i('k:$key v:$value'));
    }
    return options;
  }

  @override
  Future<FutureOr> onError(DioError err) async{
    LoggerConfig.log.e(err.message);
    
    if(err.response != null ){
      LoggerConfig.log.e(err.response.request);
    } else {
      LoggerConfig.log.e("URL");
    }
  }

  @override
  Future<FutureOr> onResponse(Response response) async{
    LoggerConfig.log.d(response.data);
  }
}
