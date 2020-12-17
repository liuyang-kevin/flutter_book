import 'package:flutter/material.dart';

class SnowingDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SnowingDemo> {
  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Color.fromRGBO(255, 65, 108, 1.0), Color.fromRGBO(255, 75, 73, 1.0)])),
          width: mediaQuery.width,
          child: Stack(
            children: [
              CustomPaint(
                size: Size(mediaQuery.width, mediaQuery.height),
                painter: _CPainter(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
