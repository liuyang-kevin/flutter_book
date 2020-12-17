import 'dart:math';

import 'package:flutter/material.dart';

class BlobFieldDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

var random = Random(100);
double maxRadius = 6;
double maxSpeed = 0.2;
double maxTheta = 2.0 * pi;

class _State extends State<BlobFieldDemo> with TickerProviderStateMixin {
  List<Particle> particles = [];
  AnimationController ctrl;
  Animation<double> anim;

  @override
  void initState() {
    super.initState();
    ctrl = AnimationController(vsync: this, duration: Duration(milliseconds: 16));
    anim = Tween<double>(begin: 0, end: 300).animate(ctrl)
      ..addListener(() {
        if (particles.isEmpty) {
          particles = createBlobField(context);
        } else {
          updateBlobField(particles);
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
                painter: _CPainter(random, particles, anim.value),
              ),
            ],
          ),
        ),
      ),
    );
  }

  var t = 0.0;
  var dt = 0.01;
  var radiusFactor = 10;

  void updateBlobField(List<Particle> particles) {
    t += dt;
    // move the particles around in its orbit
    particles.forEach((element) {
      element.pos = polarToCartesian(element.radius * radiusFactor, element.theta + t) + element.originPos;
      // element.pos = polarToCartesian(element.radius * radiusFactor, element.theta + t) + element.originPos;
    });
  }
}

/// 根据坐标与sin，cos的关系， x与cos有关，y与sin有关
/// cos分解出x轴方向的速度，sin分解出y轴速度。这里用Offset来代表矢量速度的方向
Offset polarToCartesian(double speed, double theta) {
  return Offset(speed * cos(theta), speed * sin(theta));
}

class _CPainter extends CustomPainter {
  List<Particle> particles;
  Random random;
  double animValue = 0;
  _CPainter(this.random, this.particles, this.animValue);

  @override
  void paint(Canvas canvas, Size size) {
    particles.forEach((p) {
      var paint = Paint()
        ..color = p.color
        ..blendMode = BlendMode.modulate;
      canvas.drawCircle(p.pos, p.radius, paint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

Color getColor(Random random, double d, double a) {
  final a = 255;
  final r = ((sin(d * 2 * pi) * 127.0 + 127)).toInt();
  final g = ((cos(d * 2 * pi) * 127.0 + 127)).toInt();
  final b = random.nextInt(255);
  return Color.fromARGB(a, r, g, b);
}

List<Particle> createBlobField(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final o = Offset(size.width / 2, size.height / 2);
  final n = 5; // number of blobs
  final r = size.width / n; // radius of the blob
  final a = 0.2; // alpha

  var res = <Particle>[];

  blobField(res, r, n, a, o);
  return res;
}

List<Particle> blobField(List<Particle> res, double r, int n, double a, Offset o) {
  if (r < 10) return [];
  res.add(Particle()
    ..radius = r / n //
    ..theta = 0
    ..pos = o
    ..originPos = o
    ..color = Colors.black);

  // add orbital blobs
  var theta = 0.0;
  var dTheta = 2 * pi / n;
  for (var i = 0; i < n; i++) {
    var pos = polarToCartesian(r, theta) + o;
    res.add(Particle()
      ..theta = theta
      ..pos = pos
      ..originPos = o // 自传
      // ..originPos = pos // 自身原点公转
      // ..radius = r / n
      ..radius = r / 3
      ..color = getColor(random, i.toDouble(), a));
    theta += dTheta;
    var f = 0.43;
    blobField(res, r * f, n, a * 1.5, pos);
    // res.addAll();
  }
  return res;
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
