import 'package:flutter/material.dart';
import 'package:framework/framework.dart';
import 'package:fluro/fluro.dart';

import 'scaffold_route_aware.dart';

mixin SampleSetKeys on RouterKeys {
  var sampleScaffoldRouteAware = '/sampleScaffoldRouteAware';
}

class SampleRouterProvider extends RouterKeys with SampleSetKeys implements IRouterProvider {
  @override
  List getTotalKeys() => [];

  @override
  void initRouter(AppPageRouter router) {
    router.define(sampleScaffoldRouteAware, handler: Handler(handlerFunc: (_, params) => ScaffoldRouteAware()));
  }
}
