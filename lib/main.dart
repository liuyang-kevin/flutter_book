import 'package:book_demos/gui/theme.dart';
import 'package:flutter/material.dart';
import 'package:framework/framework.dart';

import 'common.dart';

Future<void> main() async {
  // 确保native绑定完毕 + 首帧回调
  WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {});
  await App.init(
    GVM(),
    PageRoutes(),
    PageKeys(),
    // onNextPage: routesGoNextAction,
    // onBackPage: routesGoBackAction,
  );
  // Toast.defaultLayoutManager = StyledToastBuilder();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: App.navKey,
      onGenerateRoute: App.router.generator,
      navigatorObservers: [App.routeObserver],
      theme: lightTheme,
      // initialRoute: '/sampleScaffoldRouteAware',
      // home: HeroAnimDemoPage(0),
    );
  }
}
