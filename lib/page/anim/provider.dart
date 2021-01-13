import 'package:flutter/material.dart';
import 'package:framework/framework.dart';

import 'page_hero_anim_demo.dart';
import 'page_hero_anim_demo2.dart';
import 'page_hero_demo.dart';

mixin AnimSetKeys on RouterKeys {
  var animDemoNavRoutePage = '/animDemoNavRoutePage';
  var _heroAnimDemoPage = '/heroAnimDemoPage';
  String heroAnimDemoPage({@required int depth}) {
    return pack(_heroAnimDemoPage, {'depth': depth.toString()});
  }

  var _heroAnimDemoPage2 = '/heroAnimDemoPage2';
  String heroAnimDemoPage2({@required int depth}) {
    return pack(_heroAnimDemoPage, {'depth': depth.toString()});
  }
}

class AnimSetProvider extends RouterKeys with AnimSetKeys implements IPageRouterProvider {
  @override
  List getTotalKeys() => [];

  @override
  void initPage(AppPageRouter router) {
    router.define(animDemoNavRoutePage, handler: PageHandler(__animDemoNavRoutePage));
    router.define(_heroAnimDemoPage, handler: PageHandler(__heroAnimDemoPage));
    router.define(_heroAnimDemoPage2, handler: PageHandler(__heroAnimDemoPage2));
  }
}

StatefulPage __animDemoNavRoutePage(BuildContext context, Map<String, List<String>> params) {
  return AnimDemoNavRoutePage();
}

StatefulPage __heroAnimDemoPage(BuildContext context, Map<String, List<String>> params) {
  int depth = int.tryParse(params['depth']?.first ?? "0");
  return HeroAnimDemoPage(depth);
}

StatefulPage __heroAnimDemoPage2(BuildContext context, Map<String, List<String>> params) {
  int depth = int.tryParse(params['depth']?.first ?? "0");
  return HeroAnimDemoPage2(depth);
}
