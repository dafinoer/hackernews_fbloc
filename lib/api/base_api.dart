import 'package:dio/dio.dart';

class BaseApi {
  static Future<dynamic> getData(
      {String url, 
      Map<String, dynamic> queryParams
      }) async {
        
    try {
      final result = await Dio().get(url, queryParameters: queryParams);

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
