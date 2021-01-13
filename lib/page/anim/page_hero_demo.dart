import 'package:flutter/material.dart';
import 'package:framework/framework.dart';

class AnimDemoNavRoutePage extends StatefulPage {
  AnimDemoNavRoutePage();

  @override
  ReduxState<int, StatefulWidget> createState() => _AnimDemoNavRoutePageState();
}

class _AnimDemoNavRoutePageState extends ReduxState<int, AnimDemoNavRoutePage> {
  @override
  Scaffold buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          child: Text('Go!'),
          onPressed: () {
            Navigator.of(context).push(_createRoute());
          },
        ),
      ),
    );
  }

  @override
  int initViewModel() => 1;
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Page2(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class Page2 extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('Page 2'),
      ),
    );
  }
}
