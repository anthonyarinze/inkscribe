import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:inkscribe/utils/dio_manager/dio_interceptor.dart';

class DioManager {
  static Map<String, dynamic> baseHeader = {
    'Accept': "application/json",
    "Content-type": "application/json",
  };

  final Dio _dio = Dio(
    BaseOptions(
      headers: baseHeader,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(minutes: 1),
    ),
  );

  Dio get dioInstance => _dio;

  Future<void> _initializeDio() async {
    _dio.interceptors.add(DioInterceptor());
  }

  Future<Map<String, dynamic>?> post(String url, {required data}) async =>
      await _initializeDio().then((value) async => await dioInstance.post(url, data: data).then((response) => json.decode(response.data)));

  Future<Map<String, dynamic>?> get(String url, {Map<String, dynamic>? queryParameters}) async {
    await _initializeDio();
    final response = await dioInstance.get(url, queryParameters: queryParameters);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw DioException(message: "Request failed with status ${response.statusCode}", requestOptions: RequestOptions());
    }
  }
}
