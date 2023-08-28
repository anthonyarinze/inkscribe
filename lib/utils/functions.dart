import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class ReusableFunctions {
  static final Logger logger = Logger(printer: PrettyPrinter(colors: true, printTime: true, printEmojis: true));

  static void logInfo(dynamic message) => logger.i(message);

  static void logDebug(message) => logger.d(message);

  static void logError(message, {dynamic error, StackTrace? stackTrace}) {
    logger.e('An error occurred \n $message', error: error, stackTrace: stackTrace);

    if (error is DioException) {
      logger.e(error.response?.data);
    }
  }

  static Future<bool> getInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}
