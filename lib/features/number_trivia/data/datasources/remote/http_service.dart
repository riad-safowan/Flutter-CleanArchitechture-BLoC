import 'package:dio/dio.dart';

class HttpService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "http://numbersapi.com/",
  ));

  Future<Response> getRequest(String endPoint) async {
    Response response;

    try {
      response = await _dio.get(endPoint);
    } on DioError catch (e) {
      print(e.message);
      throw Exception(e.message);
    }

    return response;
  }

  initializeInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(onError: (dioError, errorInterceptorHandler) {
      print(dioError.message);
    }, onRequest: (requestOptions, requestInterceptorHandler) {
      print("${requestOptions.method} ${requestOptions.path}");
    }, onResponse: (response , responseInterceptorHandler) {
      print(response.data);
    }));
  }
}
