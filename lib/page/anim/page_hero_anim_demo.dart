import 'package:flutter/material.dart';
import 'package:framework/framework.dart';

/// hero 只支持放大， “HreoA” 前进变化到下一个页的 “HeroA‘”
class HeroAnimDemoPage extends StatefulPage {
  final int depth;
  HeroAnimDemoPage(this.depth);

  @override
  ReduxState<int, StatefulWidget> createState() => _HeroAnimDemoPageState();
}

class _HeroAnimDemoPageState extends ReduxState<int, HeroAnimDemoPage> {
  @override
  Scaffold buildScaffold(BuildContext context) {
    var w = MediaQuery.of(context).size.width / 20 * (widget.depth + 1);
    return Scaffold(
      body: Center(
        child: Container(
          width: w,
          child: PhotoHero(
            photo: "images/let_me_see.png",
            width: w,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // App.goNext(context, navKeys.heroAnimDemoPage(depth: (widget.depth + 1)));
          Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => HeroAnimDemoPage(widget.depth + 1),
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

class PhotoHero extends StatelessWidget {
  const PhotoHero({Key key, this.photo, this.onTap, this.width}) : super(key: key);

  final String photo;
  final VoidCallback onTap;
  final double width;

  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Hero(
        tag: photo,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Image.asset(photo, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
