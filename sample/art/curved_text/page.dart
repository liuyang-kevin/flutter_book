import 'dart:math';

import 'package:fast_noise/fast_noise.dart';
import 'package:flutter/material.dart';

/// 扇形旋转text
///
/// 原视频这块是show了下代码，然后卖课，要点已经copy实现，
class CurvedTextDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<CurvedTextDemo> with TickerProviderStateMixin {
  List<String> wordList = [
    "123123",
    "sdjfklsdjfkl",
    "sdfsdfx但是看见疯狂老司机福利款",
    "123123",
    "sdjfklsdjfkl",
    "sdfsdfx但是看见疯狂老司机福利款",
    "123123",
    "sdjfklsdjfkl",
    "sdfsdfx但是看见疯狂老司机福利款",
    "123123",
    "sdjfklsdjfkl",
    "sdfsdfx但是看见疯狂老司机福利款",
    "123123",
    "sdjfklsdjfkl",
    "sdfsdfx但是看见疯狂老司机福利款",
    "123123",
    "sdjfklsdjfkl",
    "sdfsdfx但是看见疯狂老司机福利款",
    ".",
    ".",
    ".",
    ".",
    ".",
    ".",
    ".",
    ".",
    ".",
    ".",
    ".",
    ".",
    ".",
    ".",
    ".",
  ];
  double startAngle = 0.0;

  AnimationController ctrl;
  Animation<double> anim;

  @override
  void initState() {
    super.initState();
    ctrl = AnimationController(vsync: this, duration: Duration(milliseconds: 25));
    anim = Tween<double>(begin: 0, end: 200).animate(ctrl)
      ..addListener(() {
        startAngle -= 0.005;
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          ctrl.repeat();
        } else if (status == AnimationStatus.dismissed) {
          ctrl.forward();
        }
      });
    ctrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: mediaQuery.width,
        child: Stack(
          children: [
            CustomPaint(
              size: Size(mediaQuery.width, mediaQuery.height),
              painter: _CPainter(startAngle, wordList),
            ),
          ],
        ),
      ),
    );
  }
}

class _CPainter extends CustomPainter {
  final double startAngle;
  final List<String> wordList;

  final style1 = TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold);
  final style2 = TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.normal);
  final style3 = TextStyle(color: Colors.purple, fontSize: 16, fontWeight: FontWeight.normal);

  final arcStyle2 = Paint()
    ..color = Colors.black
    ..strokeWidth = 100.0
    ..style = PaintingStyle.stroke;

  final arcStyle1 = Paint()
    ..color = Colors.yellowAccent
    ..strokeWidth = 70.0
    ..style = PaintingStyle.stroke;

  final W = 350.0;

  _CPainter(this.startAngle, this.wordList);

  @override
  void paint(Canvas canvas, Size size) {
    drawBackground(canvas, size);
    final frameCenter = Offset(size.width / 2.0, size.height / 2.0);
    final c = Offset(frameCenter.dx - W / 2.0, frameCenter.dy + W / 2.0);
    final r = W / 2.0;
    final w1 = 4.0 * pi / 180.0;
    final w2 = 7.0 * pi / 180.0;
    final rect = Rect.fromCenter(center: frameCenter, width: W, height: W);
    canvas.clipRect(rect);

    drawTextArc(canvas, c, r, w1, "你好, Hello, Hi", style2);

    drawTextArc(canvas, c, r - 70, w2, "2020", style1);

    // drawArc(canvas, c, arcStyle1, r - 40);

    var w3 = startAngle;
    wordList.forEach((text) {
      drawTextSlant(canvas, c, r + 10.0, w3, text, style3);
      w3 += 10.0 * pi / 180.0;
    });

    drawFrame(canvas, frameCenter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  TextPainter measureText(Canvas canvas, String text, TextStyle style) {
    var tSpan = TextSpan(text: text, style: style);
    var textPainter = TextPainter(text: tSpan, textDirection: TextDirection.ltr);
    textPainter.layout(minWidth: 0, maxWidth: double.maxFinite);
    return textPainter;
  }

  void drawTextArc(Canvas canvas, Offset arcCenter, double radius, double a, String text, TextStyle style) {
    final pos = Offset(0, -radius);
    text.split('').forEach((c) {
      final tp = measureText(canvas, c, style);
      final w = tp.width + 5.0;
      final double alpha = asin(w / (2 * radius));
      canvas.save();
      canvas.translate(arcCenter.dx, arcCenter.dy);
      a += alpha;
      canvas.rotate(a);
      a += alpha;
      tp.paint(canvas, pos + Offset(-w / 2.0, 0.0));
      canvas.restore();
    });
  }

  void drawTextSlant(Canvas canvas, Offset arcCenter, double radius, double w, String text, TextStyle style) {
    final pos = Offset(radius, 0);
    canvas.save();
    canvas.translate(arcCenter.dx, arcCenter.dy);
    canvas.rotate(w);
    final tp = measureText(canvas, text, style);
    final ww = tp.height;
    tp.paint(canvas, pos + Offset(0, -ww / 2.0));
    canvas.restore();
  }

  /// 绘制背景渐变，渐变中心对齐绘制内容的左下角
  void drawBackground(Canvas canvas, Size size) {
    var gradient = RadialGradient(
      center: Alignment(-W / size.width + 0.2, W / size.height - 0.2),
      radius: 1.0,
      colors: [Color(0xff506475), Color(0xff01182b)],
      stops: [0.0, 1.0],
    );
    var rect = Rect.fromLTWH(0, 0, size.width, size.height);
    var p = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, p);
  }

  void drawFrame(Canvas canvas, Offset frameCenter) {
    var border = Paint()
      ..color = Colors.black
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;
    var rect = Rect.fromCenter(center: frameCenter, width: W, height: W);
    canvas.drawRect(rect, border);
  }
}
