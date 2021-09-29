import 'dart:io';

import 'package:injectable/injectable.dart';

@LazySingleton()
class NetworkChecker {
  Future<bool> get hasConnection async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (_) {
      return false;
    }
  }
}
