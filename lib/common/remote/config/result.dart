import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

enum Status { succes, error }

class Result<T> {
  final int code;
  final Status status;
  final T body;
  final DioErrorType dioError;
  final dynamic errorBody;

  Result(
      {@required this.status,
      @required this.body,
      this.code = 0,
      this.dioError,
      this.errorBody});

  static Result<T> success<T>(T data) {
    return Result(status: Status.succes, body: data);
  }

  static Result<T> error<T>(
      {DioErrorType error, dynamic errorParams, int code, dynamic errorBody}) {
    return Result(
        status: Status.error,
        body: null,
        dioError: error,
        code: code,
        errorBody: errorBody);
  }
}
