import 'interface/voice_echo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'interface/web_view_utils.dart';

const Widget _wErrInfo = SizedBox(child: Text("缺少实现"));

/// 平台出口
///
/// * UI 端需要维护好本类
/// * UI 人员需要的原生支持全部从这个中间件出
/// * UI 作健壮性维护，确保参数正确，然后送达平台端实现。
class AppPlatformService {
  static final AppPlatformService _singleton = AppPlatformService._internal();

  factory AppPlatformService() {
    return _singleton;
  }

  AppPlatformService._internal() {
    if (kIsWeb) {}
  }

  IVoiceEcho _implVoiceEcho;
  IWebViewUtils _iWebViewUtils;

  void start() {
    _implVoiceEcho?.start();
  }

  void stop() {
    _implVoiceEcho?.stop();
  }

  Widget get wForMFCC => _implVoiceEcho?.visualMFCC ?? _wErrInfo;

  Widget wOutsideWebPage(String url) {
    return _iWebViewUtils?.outsideWebPage(url) ?? _wErrInfo;
  }
}
