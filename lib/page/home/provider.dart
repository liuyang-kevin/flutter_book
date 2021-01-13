import 'package:flutter/material.dart';
import 'package:framework/framework.dart';

import 'page_app_home.dart';
import 'page_md_viewer.dart';

mixin HomeSetKeys on RouterKeys {
  var appHomePage = '/';
  var markdownViewer = '/markdownViewer';
}

class HomeSetProvider extends RouterKeys with HomeSetKeys implements IPageRouterProvider {
  @override
  List getTotalKeys() => [];

  @override
  void initPage(AppPageRouter router) {
    router.define(appHomePage, handler: PageHandler(_homePage));
    router.define(markdownViewer, handler: PageHandler(_markdownViewer));
  }
}

StatefulPage _homePage(BuildContext context, Map<String, List<String>> params) {
  return AppHomePage();
}

StatefulPage _markdownViewer(BuildContext context, Map<String, List<String>> params) {
  var filePath = params['filePath']?.first ?? 'README.md';
  return MdViewerPage(filePath);
}
