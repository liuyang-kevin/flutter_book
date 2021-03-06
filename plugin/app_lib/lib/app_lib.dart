// You have generated a new plugin project without
// specifying the `--platforms` flag. A plugin project supports no platforms is generated.
// To add platforms, run `flutter create -t plugin --platforms <platforms> .` under the same
// directory. You can also find a detailed instruction on how to add platforms in the `pubspec.yaml` at https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'dart:async';

import 'package:flutter/services.dart';

class AppLib {
  static const MethodChannel _channel = MethodChannel('app_lib');

  static Future<String> get platformVersion async => await _channel.invokeMethod('getPlatformVersion');

  static Future<String> api() async => await _channel.invokeMethod('api');
}
