import 'dart:math';

import 'package:flutter/material.dart';

/// 圆形递归生成，旋转
///
/// https://www.youtube.com/watch?v=Ka_DPxi4i7o&list=PLP_fzAt_4T3TcgZ0UYDjIPUYsOLJWdgT-&index=2&ab_channel=CodingwithIndy
class BlobFieldDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

double maxRadius = 6;
double maxSpeed = 0.2;
double maxTheta = 2.0 * pi;

class _State extends State<BlobFieldDemo> with TickerProviderStateMixin {
  List<Particle> particles = [];
  AnimationController ctrl;
  Animation<double> anim;
  var random = Random(100);

  @override
  void initState() {
    super.initState();
    ctrl = AnimationController(vsync: this, duration: Duration(milliseconds: 16));
    anim = Tween<double>(begin: 0, end: 300).animate(ctrl)
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
                painter: _CPainter(random, particles, anim.value),
              ),
              Column(
                children: [
                  SizedBox(height: 50),
                  Slider(
                    value: radiusFactor < 1 ? 1 : radiusFactor,
                    min: 1.0,
                    max: 10.0,
                    onChanged: (v) {
                      radiusFactor = v;
                      setState(() {});
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  var t = 0.0;
  var dt = 0.01;
  var radiusFactor = 5.0;

  void updateBlobField() {
    t += dt;
    // move the particles around in its orbit
    particles.forEach((element) {
      radiusFactor = mapRange(sin(t), -1, 1, 2, 10);
      // element.pos = polarToCartesian(element.radius, element.theta + t) + element.originPos;
      element.pos = polarToCartesian(element.radius * radiusFactor, element.theta + t) + element.originPos;
      // element.pos = polarToCartesian(element.radius * radiusFactor, element.theta + t) + element.originPos;
    });
  }

  double mapRange(double value, double min1, double max1, double min2, double max2) {
    double range1 = min1 - max1;
    double range2 = min2 - max2;
    return min2 + range2 * value / range1;
  }

  Color getColor(Random random, double d, double a) {
    final a = 255;
    final r = ((sin(d * 2 * pi) * 127.0 + 127)).toInt();
    final g = ((cos(d * 2 * pi) * 127.0 + 127)).toInt();
    final b = random.nextInt(255);
    return Color.fromARGB(a, r, g, b);
  }

  void createBlobField() {
    final size = MediaQuery.of(context).size;
    final o = Offset(size.width / 2, size.height / 2);
    final n = 5; // number of blobs
    final r = size.width / n; // radius of the blob
    final a = 0.2; // alpha

    blobField(r, n, a, o);
  }

  void blobField(double r, int n, double a, Offset o) {
    if (r < 10) return;
    particles.add(
      Particle()
        ..radius = r / 3 //
        ..theta = 0
        ..pos = o
        ..originPos = o
        // ..color = Colors.red
        ..color = getColor(random, n.toDouble(), a),
    );

    // add orbital blobs
    var theta = 0.0;
    var dTheta = 2 * pi / n;
    for (var i = 0; i < n; i++) {
      var pos = polarToCartesian(r, theta) + o;
      particles.add(Particle()
            ..theta = theta
            ..pos = pos
            ..originPos = o // 自传
            // ..originPos = pos // 自身原点公转
            // ..radius = r / n
            ..radius = r / 3
            ..color = getColor(random, i.toDouble() / n, a)
          // ..color = Colors.black12,
          );
      theta += dTheta;
      var f = 0.5;
      blobField(r * f, n, a * 1.5, pos);
    }
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
      var paint = Paint();
      paint.color = p.color;
      paint.blendMode = BlendMode.modulate;

      //
      // ..blendMode = BlendMode.srcIn
      canvas.drawCircle(p.pos, p.radius, paint);
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
