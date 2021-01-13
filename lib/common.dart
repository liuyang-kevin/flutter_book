import 'package:book_demos/page/media/provider.dart';
import 'package:framework/framework.dart';

import 'page/anim/provider.dart';
import 'page/home/provider.dart';
import 'page/samples/provider.dart';

PageKeys get navKeys => App.routerKeys<PageKeys>();

/// 全局ViewModel，例如红点、推送等
class GVM extends GlobalViewModel {
  final _dataSet = <SingleViewModel>{};

  @override
  Set<SingleViewModel> get dataSet => _dataSet;
}

class PageRoutes extends Routes {
  @override
  List<IRouterProvider> get others => [SampleRouterProvider(), MediaScaffoldProvider()];

  @override
  List<IPageRouterProvider> get pages => [HomeSetProvider(), AnimSetProvider()];
}

class PageKeys extends RouterKeys with HomeSetKeys, AnimSetKeys, SampleSetKeys, MediaSetKeys {
  @override
  List getTotalKeys() => [];
}
