import 'package:flutter/material.dart';

void quickToolPageForPop(BuildContext context, {Widget newPage}) {
  Navigator.of(context).push(PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        newPage ??
        Scaffold(
          appBar: AppBar(),
          body: Center(child: Text('Page 2')),
        ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  ));
}
