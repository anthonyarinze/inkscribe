import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class ReusableFunctions {
  static const FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();

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

  Future<void> cacheUsername(String username) async {
    flutterSecureStorage.write(key: 'username', value: username);
  }

  Future<String?> getCachedUsername() async {
    return flutterSecureStorage.read(key: 'username');
  }

  void logUid() {
    logDebug(FirebaseAuth.instance.currentUser!.uid);
  }
}
