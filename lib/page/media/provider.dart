import 'package:fluro/fluro.dart';
import 'package:framework/framework.dart';

import 'scaffold_echo_voice.dart';

mixin MediaSetKeys on RouterKeys {
  var scaffoldEchoVoice = '/scaffoldEchoVoice';
}

class MediaPageProvider extends RouterKeys with MediaSetKeys implements IPageRouterProvider {
  @override
  List getTotalKeys() => [];

  @override
  void initPage(AppPageRouter router) {}
}

class MediaScaffoldProvider extends RouterKeys with MediaSetKeys implements IRouterProvider {
  @override
  List getTotalKeys() => [];

  @override
  void initRouter(AppPageRouter router) {
    router.define(scaffoldEchoVoice, handler: Handler(handlerFunc: (_, params) => ScaffoldEchoVoice()));
  }
}
