import 'dart:math';

import 'package:flutter/material.dart';

/// 其实是个浮动效果。
/// https://www.youtube.com/watch?v=vMy9NCzbAIY&list=PLP_fzAt_4T3TcgZ0UYDjIPUYsOLJWdgT-&index=1&ab_channel=CodingwithIndy
class SnowingDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

double maxRadius = 6;
double maxSpeed = 0.2;
double maxTheta = 2.0 * pi;

class _State extends State<SnowingDemo> with TickerProviderStateMixin {
  List<Particle> particles;
  var random = Random(100);
  AnimationController ctrl;
  Animation<double> anim;

  @override
  void initState() {
    super.initState();
    ctrl = AnimationController(vsync: this, duration: Duration(milliseconds: 16));
    anim = Tween<double>(begin: 0, end: 300).animate(ctrl)
      ..addListener(() {
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
    particles = List.generate(1000, (index) {
      return Particle()
        ..color = randomColor(random)
        ..pos = Offset.zero
        ..speed = random.nextDouble() * maxSpeed // 0-0.2
        ..theta = random.nextDouble() * maxTheta // 0->2pi
        ..radius = random.nextDouble() * maxRadius;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient:
                  LinearGradient(colors: [Color.fromRGBO(255, 255, 255, 1.0), Color.fromRGBO(255, 255, 255, 1.0)])),
          width: mediaQuery.width,
          child: Stack(
            children: [
              CustomPaint(
                size: Size(mediaQuery.width, mediaQuery.height),
                painter: _CPainter(random, particles, anim.value),
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 根据坐标与sin，cos的关系， x与cos有关，y与sin有关
/// cos分解出x轴方向的速度，sin分解出y轴速度。这里用Offset来代表矢量速度的方向
Offset PolarToCartesian(double speed, double theta) {
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
      var velocity = PolarToCartesian(p.speed, p.theta);
      var dx = p.pos.dx + velocity.dx;
      var dy = p.pos.dy + velocity.dy;
      if (p.pos.dx < 0 || p.pos.dx > size.width) {
        dx = random.nextDouble() * size.width;
      }
      if (p.pos.dy < 0 || p.pos.dy > size.height) {
        dy = random.nextDouble() * size.height;
      }
      p.pos = Offset(dx, dy);
    });

    particles.forEach((p) {
      var paint = Paint()..color = p.color;
      canvas.drawCircle(p.pos, p.radius, paint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Particle {
  Offset pos;
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
