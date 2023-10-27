import 'dart:math';

import 'package:flutter/material.dart' show Colors, CustomPainter, Matrix4;
import 'package:flutter/painting.dart';

class InfiniteRender extends CustomPainter {
  final String text;

  InfiniteRender(this.text);

  @override
  void paint(Canvas canvas, Size size) {
    var radius = 150.0;
    final center = size.center(Offset.zero);

    var angle = 3 * pi / 2;
    for (var i = 0; i < text.length; i++) {
      //rotate canvas on center
      // canvas.save();
      // canvas.translate(center.dx, center.dx);
      // canvas.rotate(angle);

      radius = 150.0 - 0.10 * i;
      final offset = Offset(radius * cos(angle), radius * sin(angle));
      final textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
          text: text[i],
          style: const TextStyle(
            fontSize: 12.0,
            color: Colors.black,
          ),
        ),
      )..layout();
      textPainter.paint(canvas, center + offset);
      final paint = Paint()
        ..color = Colors.red
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke;
      // canvas.translate(-center.dx, -center.dx);
      // canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
