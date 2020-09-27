import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:hackernews_flutter/common/remote/config/result.dart';

typedef ResponseConverter<T> = T Function(dynamic response);

Future<Result<T>> callApi<T>(Future<Response<dynamic>> call, ResponseConverter<T> converter) async {
  try {
    final response = await call;
    var transform = converter(response.data);
    return Result.success(transform);
  } on DioError catch (e) {
    return Result.error(
        error: e.type,
        code: e.response?.statusCode,
        errorBody: e.response?.data);
  }
}


void responseHandler<T>(
    Result<T> result,
    {@required Function(T data) onSuccess,
    @required Function(DioErrorType dioError, int code, dynamic errorBody) onError}) {
  switch (result.status) {
    case Status.succes:
      onSuccess(result.body);
      break;
    case Status.error:
      onError(result.dioError, result.code, result.errorBody);
      break;
    default:
      throw ArgumentError();
  }
}
