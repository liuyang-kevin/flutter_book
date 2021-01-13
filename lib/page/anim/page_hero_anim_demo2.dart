import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:framework/framework.dart';

/// “HreoA” 前进变化到下一个页的 “HeroA‘”
///
/// 目标变形。
class HeroAnimDemoPage2 extends StatefulPage {
  final int depth;
  HeroAnimDemoPage2(this.depth);

  @override
  ReduxState<int, StatefulWidget> createState() => _HeroAnimDemoPage2State();
}

class _HeroAnimDemoPage2State extends ReduxState<int, HeroAnimDemoPage2> {
  @override
  Scaffold buildScaffold(BuildContext context) {
    var w = MediaQuery.of(context).size.width / 20 * (widget.depth + 1);
    return Scaffold(
      body: Center(
        child: Container(
          // color: Colors.black26,
          child: PhotoHero(widget.depth, photo: "images/let_me_see.png", width: w),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // App.goNext(context, navKeys.heroAnimDemoPage(depth: (widget.depth + 1)));
          Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => HeroAnimDemoPage2(widget.depth + 1),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return child;
            },
          ));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  int initViewModel() => 1;
}

/// hero 需要tag 与 child支持；
class PhotoHero extends StatelessWidget {
  const PhotoHero(this.depth, {Key key, this.photo, this.onTap, this.width}) : super(key: key);

  final String photo;
  final VoidCallback onTap;
  final double width;
  final int depth;
  Widget build(BuildContext context) {
    // 使用timeDilation属性可以在调试时减慢转换速度。
    timeDilation = 5.0;
    var r = Random(DateTime.now().millisecondsSinceEpoch);

    Widget child;
    var size = r.nextDouble() * 200.0;

    child = RadialExpansion(
      maxRadius: size,
      child: Hero(
        tag: photo, // tag 标识“英雄”的对象。在两个屏幕上它必须相同。
        child: SizedBox(
          width: size,
          height: size,
          child: Material(
            color: Colors.black38,
            child: InkWell(
              onTap: () => App.goBack(context),
              child: Image.asset(photo, fit: BoxFit.contain),
            ),
          ),
        ), // 跨屏幕制作动画的小部件。
      ),
    );

    if (depth % 2 == 0) {
    } else {}

    return Container(
      width: size,
      height: size,
      color: Colors.red,
      child: child,
    );
    return Container(
      padding: EdgeInsets.fromLTRB(
        r.nextDouble() * 300.0,
        r.nextDouble() * 300.0,
        r.nextDouble() * 300.0,
        r.nextDouble() * 300.0,
      ),
      child: Hero(
        tag: photo, // tag 标识“英雄”的对象。在两个屏幕上它必须相同。
        child: child, // 跨屏幕制作动画的小部件。
      ),
    );
  }
}

class RadialExpansion extends StatelessWidget {
  RadialExpansion({
    Key key,
    this.maxRadius,
    this.child,
  })  : clipRectSize = 2.0 * (maxRadius / math.sqrt2),
        super(key: key);

  final double maxRadius;
  final clipRectSize;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new ClipOval(
      child: new Center(
        child: new SizedBox(
          width: clipRectSize,
          height: clipRectSize,
          child: new ClipRect(
            child: child, // Photo
          ),
        ),
      ),
    );
  }
}
