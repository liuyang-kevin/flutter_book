import 'dart:async';
import 'dart:convert';
// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show window;

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:http/http.dart' as http;

/// A web implementation of the Aaaa plugin.
class AppLibWeb {
  static void registerWith(Registrar registrar) {
    final channel = MethodChannel('app_lib', const StandardMethodCodec(), registrar);

    final pluginInstance = AppLibWeb();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  /// Handles method calls over the MethodChannel of this plugin.
  /// Note: Check the "federated" architecture for a new way of doing this:
  /// https://flutter.dev/go/federated-plugins
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'getPlatformVersion':
        return getPlatformVersion();
        break;
      case 'api':
        return api();
        break;
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'app_lib for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  /// Returns a [String] containing the version of the platform.
  Future<String> getPlatformVersion() {
    final version = html.window.navigator.userAgent;
    return Future.value(version);
  }

  Future<String> api() async {
    //https://test-api.dacallapp.com/admin/user/login
    var param = {'name': 'admin', 'pwd': 'cf9ea0b4a6c5a9dcd80c586a293f31b1'};
    final body = await _fetchData();
    return Future.value(body);
  }

  Future<String> _fetchData() async {
    final res = await http.get('https://test-api.dacallapp.com/admin/user/login');
    if (res.statusCode == 200) {
      print('AppLibWeb._fetchData ${res.body}');
      // var v = json.decode(res.body);
      return res.body;
    }
    return '';
  }
}
