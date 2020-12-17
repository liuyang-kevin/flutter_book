import 'package:flutter/material.dart';

class ElasticSidebarDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<ElasticSidebarDemo> {
  Offset _offset = Offset(0, 0);
  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    double sidebarWidth = mediaQuery.width * 0.65;
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromRGBO(255, 65, 108, 1.0),
              Color.fromRGBO(255, 75, 73, 1.0),
            ]),
          ),
          width: mediaQuery.width,
          child: Stack(
            children: [
              SizedBox(
                width: sidebarWidth,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    if (details.localPosition.dx <= sidebarWidth) {
                      _offset = details.localPosition;
                      setState(() {});
                    }
                  },
                  onPanEnd: (details) {
                    _offset = Offset(0, 0);
                    setState(() {});
                  },
                  child: Stack(
                    children: [
                      CustomPaint(
                        size: Size(sidebarWidth, mediaQuery.height),
                        painter: _Drawer(_offset),
                      ),
                      Container(
                        height: mediaQuery.height,
                        width: sidebarWidth,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              height: mediaQuery.height * .25,
                              child: Center(
                                child: Column(
                                  children: [
                                    Container(child: Icon(Icons.place), width: sidebarWidth / 2),
                                    Text("fssjkdjflaskdf", style: TextStyle(color: Colors.black45))
                                  ],
                                ),
                              ),
                            ),
                            Divider(thickness: 1),
                            Container(
                              width: double.infinity,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _Drawer extends CustomPainter {
  final Offset offset;
  _Drawer(this.offset);

  double ctrlPointX(double width) {
    if (offset.dx == 0) {
      return width;
    } else {
      return offset.dx > width ? offset.dx : width + (offset.dx * 0.2);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint p = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    Path path = Path();
    path.moveTo(-size.width, 0);
    path.lineTo(size.width, 0);
    // path.lineTo(size.width, size.height);
    path.quadraticBezierTo(ctrlPointX(size.width), offset.dy, size.width, size.height);
    path.lineTo(-size.width, size.height);
    path.close();
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
