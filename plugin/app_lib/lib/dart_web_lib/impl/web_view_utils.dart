import 'dart:html';
import 'dart:ui' as ui;

import 'package:book_demos/platform/interface/web_view_utils.dart';
import 'package:flutter/widgets.dart';

class ImplWebViewUtils implements IWebViewUtils {
  @override
  Widget outsideWebPage(String url) {
    final IFrameElement _iframeElement = IFrameElement();
    _iframeElement.src = url;
    _iframeElement.style.border = 'none';
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
      (int viewId) => _iframeElement,
    );
    return HtmlElementView(key: UniqueKey(), viewType: 'iframeElement');
  }
}
