import 'dart:ui';

import 'package:bezier/bezier.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' show Vector2;

class BezierPageDemo extends StatefulWidget {
  const BezierPageDemo({Key? key}) : super(key: key);

  @override
  State<BezierPageDemo> createState() => _BezierPageDemoState();
}

class _BezierPageDemoState extends State<BezierPageDemo> {
  var offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onPanUpdate: (details) {
          print(details.localPosition);
          setState(() {
            offset = details.localPosition;
          });
        },
        child: Container(
          color: Colors.blue,
          child: CustomPaint(
            size: MediaQuery.of(context).size,
            painter: BezierPainter(offset),
          ),
        ),
      ),
    );
  }
}

class BezierPainter extends CustomPainter {
  final Offset endPoint;

  BezierPainter(this.endPoint);

  @override
  void paint(Canvas canvas, Size size) {
    final startPoint = Offset(size.width / 2, 100);
    final rotate = startPoint.dx > endPoint.dx ? 1 : -1;
    // final middlePoint = startPoint + (endPoint - startPoint) / 2 + Offset(rotate * 50, 100);
    final middlePoint = Offset(endPoint.dx, startPoint.dy);
    final path = createPath(startPoint, endPoint);

    final points = <Offset>[];
    for (var i = 0.0; i < 1; i += 0.001) {
      final point = path.pointAt(i).toOffset();
      points.add(point);
    }

    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    canvas.drawPoints(PointMode.points, [startPoint, middlePoint, endPoint], paint);
    paint.color = Colors.red;
    canvas.drawPoints(PointMode.points, points, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

QuadraticBezier createPath(Offset startPoint, Offset endPoint) {
  final rotate = startPoint.dx > endPoint.dx ? 1 : -1;

  final middlePoint = Offset(endPoint.dx, startPoint.dy);
  // final middlePoint = startPoint + (endPoint - startPoint) / 2 + Offset(rotate * 20, 40);
  final quadraticCurve = QuadraticBezier([
    startPoint.toVector2(),
    middlePoint.toVector2(),
    endPoint.toVector2(),
  ]);
  return quadraticCurve;
}

extension _OffsetToVector2 on Offset {
  Vector2 toVector2() => Vector2(dx, dy);
}

extension _Vector2ToOffset on Vector2 {
  Offset toOffset() => Offset(x, y);
}
