import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

@module
abstract class ExternalLibrariesModule {
  @preResolve
  Future<SharedPreferences> get prefs {
    WidgetsFlutterBinding.ensureInitialized();
    return SharedPreferences.getInstance();
  }

  @lazySingleton
  http.Client get httpClient => http.Client();
}
