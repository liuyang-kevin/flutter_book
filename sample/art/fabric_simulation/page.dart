import 'dart:math';

import 'package:fast_noise/fast_noise.dart';
import 'package:flutter/material.dart';

/// 类似纹理的效果
///
/// 注入灵魂 - perlin noise
///
/// https://www.youtube.com/watch?v=mrPeqMQHgUU&list=PLP_fzAt_4T3TcgZ0UYDjIPUYsOLJWdgT-&index=7&ab_channel=CodingwithIndy
class FabricSimulationDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<FabricSimulationDemo> with TickerProviderStateMixin {
  List<Particle> particles = [];
  int particleCount = 50;
  Size size;
  Offset origin;
  double radius;

  AnimationController ctrl;
  Animation<double> anim;
  var random = Random(100);

  @override
  void initState() {
    super.initState();
    ctrl = AnimationController(vsync: this, duration: Duration(milliseconds: 16));
    anim = Tween<double>(begin: 0, end: 200).animate(ctrl)
      ..addListener(() {
        if (particles.isEmpty) {
          createBlobField();
        } else {
          updateBlobField();
        }
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
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: mediaQuery.width,
          child: Stack(
            children: [
              CustomPaint(
                size: Size(mediaQuery.width, mediaQuery.height),
                painter: _CPainter(random, particles, Size(mediaQuery.width, mediaQuery.height), artW),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double artW = 400.0;
  int artStep = 5;
  void createBlobField() {
    blobField();
  }

  void blobField() {
    for (var y = 0; y < artW / artStep; y++) {
      var x = 0.0;
      var p = Particle()
        ..pos = Offset(x, y.toDouble())
        ..radius = 3.0
        ..color = Colors.green
        ..originPos = Offset(x, y.toDouble());
      particles.add(p);
    }
  }

  Offset genRandomPos(double radius) {
    var t = random.nextDouble() * 2 * pi;
    return polarToCartesian(radius, t);
  }

  var t = 0.0;
  var dt = 0.05;
  var radiusFactor = 5.0;

  void updateBlobField() {
    particles.forEach((p) {
      setParticle(p);
    });
    t += dt;
  }

  Color getColor(Random random, double d, double a) {
    final a = 255;
    final r = ((sin(d * 2 * pi) * 127.0 + 127)).toInt();
    final g = ((cos(d * 2 * pi) * 127.0 + 127)).toInt();
    final b = random.nextInt(255);
    return Color.fromARGB(a, r, g, b);
  }

  var perlin = PerlinNoise();
  void setParticle(Particle p) {
    var x = p.originPos.dx;
    var y = p.originPos.dy * artStep;

    var xx = x * 0.2;
    var yy = y * 0.01;
    var zz = t * 0.5;

    // var n = perlin.singlePerlin3(1942, xx, yy, zz);
    // var n = perlin.singlePerlin2(222, yy, t);
    var n = perlin.singlePerlinFractalFBM2(yy, t);

    var dx = mapRange(n, 0, 1, -artStep.toDouble(), artStep.toDouble());
    var dy = mapRange(n, 0, 1, -artStep.toDouble(), artStep.toDouble());
    var px = x + dx;
    var py = y + dy;
    p.pos = Offset(px, py);
  }
}

class _CPainter extends CustomPainter {
  List<Particle> particles;
  Random random;

  Size canvasSize;
  Offset center;
  final double artW;

  _CPainter(this.random, this.particles, this.canvasSize, this.artW) {
    center = Offset(canvasSize.width / 2, canvasSize.height / 2);
  }

  @override
  void paint(Canvas canvas, Size size) {
    var dx1 = canvasSize.width / 2 - artW / 2;
    var dy1 = canvasSize.height / 2 - artW / 2;
    var border = Paint()
      ..color = Colors.black
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;
    var rect = Rect.fromCenter(center: center, width: artW + 10, height: artW + 10);
    canvas.drawRect(rect, border);

    particles.forEach((p) {
      var paint = Paint();
      paint.color = p.color;
      paint.strokeWidth = 5.0;
      paint.style = PaintingStyle.stroke;
      // // paint.blendMode = BlendMode.colorBurn;
      paint.blendMode = BlendMode.colorBurn;
      var pCenter = p.pos + center + Offset(0, (-artW / 2) + (p.radius));
      canvas.drawCircle(pCenter, p.radius, paint);
      var p1 = p.originPos + Offset(dx1, dy1);
      paint.blendMode = BlendMode.modulate;
      canvas.drawLine(p1, pCenter, paint);
      canvas.drawLine(p1.translate(artW, 0), pCenter, paint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Particle {
  Offset pos;
  Offset originPos;
  Color color;
  double speed;
  double theta;

  double radius;
}

Color randomColor(Random random) {
  var a = random.nextInt(255);
  var r = random.nextInt(255);
  var g = random.nextInt(255);
  var b = random.nextInt(255);
  return Color.fromARGB(a, r, g, b);
}

/// 根据坐标与sin，cos的关系， x与cos有关，y与sin有关
/// cos分解出x轴方向的速度，sin分解出y轴速度。这里用Offset来代表矢量速度的方向
Offset polarToCartesian(double speed, double theta) {
  return Offset(speed * cos(theta), speed * sin(theta));
}

double mapRange(double value, double min1, double max1, double min2, double max2) {
  double range1 = min1 - max1;
  double range2 = min2 - max2;
  return min2 + range2 * value / range1;
}
