import 'dart:math';

import 'package:flutter/material.dart';

/// 多圆圈抵消效果，使用了[BlendMode]的[BlendMode.colorBurn]模式，抵消了色彩叠加
///
/// 19. colorBurn：用dst函数的倒数除以src函数的倒数，然后求结果的倒数。
/// 反转组件意味着将完全饱和通道(不透明的白色)视为值0.0，而通常将值0.0(黑色、透明)视为值1.0。
///
/// https://www.youtube.com/watch?v=IxsjuSLuzyw&list=PLP_fzAt_4T3TcgZ0UYDjIPUYsOLJWdgT-&index=3&ab_channel=CodingwithIndy
class BlackCirclesDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<BlackCirclesDemo> with TickerProviderStateMixin {
  List<Particle> particles = [];
  int particleCount = 50;

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

  var origin;
  void createBlobField() {
    var size = MediaQuery.of(context).size;
    origin = Offset(size.width / 2, size.height / 2);
    var radius = size.width / 4; // radius of the blob

    blobField(origin, radius);
  }

  void blobField(Offset o, double r) {
    while (particles.length < particleCount) {
      particles.add(newParticle(o));
    }
  }

  Offset genRandomPos(double radius) {
    var t = random.nextDouble() * 2 * pi;
    return polarToCartesian(radius, t);
  }

  Particle newParticle(Offset originPos) {
    return Particle()
      ..color = Colors.grey
      ..radius = 100
      ..theta = random.nextDouble() * 2 * pi
      ..speed = 20
      ..pos = genRandomPos(100) + originPos
      ..originPos = originPos;
  }

  var t = 0.0;
  var dt = 0.01;
  var radiusFactor = 5.0;

  void updateBlobField() {
    particles.forEach((element) {
      element.pos += polarToCartesian(element.speed, element.theta);
    });
    particles.add(newParticle(origin));

    while (particles.length < particleCount * 2) {
      if (particles.isEmpty) continue;
      particles.removeAt(0);
    }
  }

  Color getColor(Random random, double d, double a) {
    final a = 255;
    final r = ((sin(d * 2 * pi) * 127.0 + 127)).toInt();
    final g = ((cos(d * 2 * pi) * 127.0 + 127)).toInt();
    final b = random.nextInt(255);
    return Color.fromARGB(a, r, g, b);
  }
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
      paint.strokeWidth = 10.0;
      paint.style = PaintingStyle.stroke;
      paint.blendMode = BlendMode.colorBurn;
      // paint.blendMode = BlendMode.xor;
      canvas.drawCircle(p.pos, p.radius, paint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Particle {
  Offset pos = Offset(0, 0);
  Offset originPos = Offset(0, 0);
  Color color = Colors.transparent;
  double speed = 0.0;
  double theta = 0.0;

  double radius = 1.0;
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
