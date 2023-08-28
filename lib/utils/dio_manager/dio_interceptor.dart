import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inkscribe/utils/functions.dart';

class DioInterceptor extends Interceptor {
  @override
  void onRequest(options, handler) async {
    ReusableFunctions.logInfo({
      "type": "Request --->",
      "url": options.uri.toString(),
      "method": options.method,
      'headers': options.headers,
      "payload": options.data,
    });
    const CircularProgressIndicator();
    handler.next(options);
  }

  @override
  void onResponse(response, handler) async {
    ReusableFunctions.logInfo({
      "type": "Response <---",
      "url": response.realUri.toString(),
      "status": response.statusCode,
      "headers": response.headers.map,
      "response": response.data,
    });
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    ReusableFunctions.logInfo({
      "error": err.error,
      "type": "Error <--!!!!!-->",
      "url": err.response?.realUri.toString(),
      "status": err.response?.statusCode,
      "response": err.response?.data,
    });

    handler.next(err);
  }
}
