import 'package:dio/dio.dart';

class BaseApi {
  static Future<dynamic> getData(
      {String url, 
      Map<String, dynamic> queryParams,
      Options options
      }) async {
        
    try {
      final result = await Dio().get(
        url, 
        queryParameters: queryParams,
        options: options
        );

      if (result.statusCode != 200) {
        throw DioError(
            error: result.statusMessage,
            type: DioErrorType.RESPONSE,
            response: result);
      }
      return result;
    } on DioError catch (e) {
      throw Exception(e);
    }
  }
}
