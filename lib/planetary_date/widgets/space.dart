import 'dart:math';

import 'package:flutter/material.dart';

class SpaceCard extends StatelessWidget {
  final Widget child;
  final Size size;

  SpaceCard({required this.child, super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Card(
          color: Color(0xFF1A112D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: RepaintBoundary(
            child: CustomPaint(
              willChange: false,
              isComplex: true,
              size: size,
              painter: StarsPainter(
                count: 100,
                radius: 1,
                color: Colors.white.withOpacity(.2),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class StarsPainter extends CustomPainter {
  final int count;
  final double radius;
  final Color color;

  StarsPainter({
    required this.count,
    required this.radius,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final random = Random();

    for (var i = 0; i < count; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
