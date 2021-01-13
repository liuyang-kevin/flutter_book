import 'dart:html';
import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:ui' as ui;

import 'package:book_demos/platform/interface/voice_echo.dart';
import 'package:flutter/widgets.dart';

// String aaa = File('../web/voice_echo.js').readAsStringSync();

class ImplVoiceEcho implements IVoiceEcho {
  ImplVoiceEcho() {
    var old = html.document.body?.getElementsByClassName("ImplVoiceEcho");
    if (old != null && old.isEmpty) {
      print("new -> ImplVoiceEcho()");
      ScriptElement script = ScriptElement();
      script.src = "assets/h5/voice_echo.js";
      document.body?.nodes.add(script);
      // document.body.append(script);

      // HtmlDocument doc = js.context['document'];
      // ScriptElement s = doc.createElement("script");
      // s.src = "assets/h5/voice_echo.js";
      // print(s);
      // print(s.runtimeType);
      // doc.body.append(s);

      // var s = html.document.createElement("script") as ScriptElement;
      // print(s);
      // print(s.runtimeType);
      // s.src = "assets/h5/voice_echo.js";
      // html.document.head.appendHtml('''
      // <script src="assets/h5/voice_echo.js"></script>
      // ''');
      // html.document.body.appendHtml('''
      // <script src="assets/h5/voice_echo.js"></script>
      // ''');

      // ScriptElement _jsLib = html.ScriptElement()
      //   ..src = "assets/h5/voice_echo.js"
      //   ..className = "ImplVoiceEcho";
      // html.document.body.insertAdjacentElement("beforeEnd", _jsLib);

      // ScriptElement _meydaLib = html.ScriptElement()
      //   ..async = false
      //   ..src = "assets/h5/assets/js/dependencies/meyda/meyda.min.js"
      //   ..className = "ImplVoiceEcho";
      // html.document.body.insertAdjacentElement("beforeEnd", _meydaLib);

      // _meydaLib.addEventListener('load', (event) {
      //   print('asdfasdf');
      //   print(_meydaLib);
      //   // js.context.callMethod("Meyda");
      // });

      // _meydaLib.src = "assets/h5/assets/js/dependencies/meyda/meyda.min.js";
    }
    // print(old);

    // html.document.head.insertAdjacentElement("beforeEnd", _jsLib);
    print("insert ImplVoiceEcho <script>");
  }

  @override
  void start() {
    if (js.context.callMethod('hasOwnProperty', ["voiceEcho"])) {
      // _voiceEchoObj ??= js.context.callMethod("VoiceEcho");
      // _voiceEchoObj.callMethod('startReocrd');
      js.context.callMethod("voiceEchoStart");
    }
    // js.context.hasProperty(property)
    // print(js.context.callMethod('hasOwnProperty', ["Document"]));
    // print(js.context.callMethod('hasOwnProperty', ["VoiceEcho"]));
    // js.context.callMethod('startVoiceEcho');
    // js.context.callMethod('window.console.log');
  }

  @override
  void stop() {
    js.context.callMethod("voiceEchoStop");
  }

  @override
  Widget get visualMFCC {
    final IFrameElement _iframeElement = IFrameElement();
    _iframeElement.src = "assets/h5/record_and_play_it_back.html";
    _iframeElement.style.border = 'none';
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
      (int viewId) => _iframeElement,
    );
    return HtmlElementView(key: UniqueKey(), viewType: 'iframeElement');
  }
}
