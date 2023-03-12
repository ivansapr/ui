import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/services.dart';

class FollowingLetters extends StatefulWidget {
  final Widget body;
  const FollowingLetters({super.key, required this.body});

  @override
  State<FollowingLetters> createState() => _FollowingLettersState();
}

class _FollowingLettersState extends State<FollowingLetters> {
  PointerHoverEvent? _mousePosition;
  final characters = <String>[];
  final positions = <Offset>[];

  final FocusNode _focusNode = FocusNode();

  void addCharacter(String char) {
    characters.add(char);
    if (positions.isEmpty) {
      positions.add(_mousePosition!.localPosition);
    } else {
      positions.add(positions.last + Offset(10, 10) * positions.last.direction);
    }
  }

  void onMouseMove(PointerHoverEvent event) {
    _mousePosition = event;

    if (characters.isEmpty) {
      return;
    }

    final newPositions = <Offset>[];
    final firstPoint = event.localPosition;
    newPositions.add(firstPoint);

    for (var i = 1; i < positions.length; i++) {
      final newPosition = positions[i - 1];
      if ((newPosition - positions[i]).distanceSquared > 400) {
        newPositions.add(newPosition);
      } else {
        newPositions.add(positions[i]);
      }
    }

    positions
      ..clear()
      ..addAll(newPositions);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: (value) {
        if (value.character != null) {
          final r = RegExp(r'\w');
          if (r.hasMatch(value.character!)) {
            setState(() {
              addCharacter(r.stringMatch(value.character!)!);
            });
          }
        }
      },
      child: MouseRegion(
        onHover: onMouseMove,
        onExit: (event) => setState(() {
          _mousePosition = null;
        }),
        opaque: false,
        child: Stack(
          children: [
            widget.body,
            if (_mousePosition != null)
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    size: MediaQuery.of(context).size,
                    isComplex: true,
                    willChange: true,
                    painter: DrawingPainter(
                      characters,
                      positions,
                      [0.4],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<String> characters;
  final List<Offset> positions;
  final List<double> angles;

  DrawingPainter(this.characters, this.positions, this.angles)
      : assert(characters.length == positions.length);

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < characters.length; i++) {
      final char = characters[i];
      final position = positions[i];
      final angle = 0.0;

      final TextStyle style = TextStyle(color: Colors.black);
      final textPainter = TextPainter(
        text: TextSpan(
          text: char,
          style: style,
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      final delta = Offset(
          position.dx - textPainter.size.width / 2, position.dy - textPainter.size.height / 2);

      // Rotate the text about textCentrePoint
      canvas.save();
      canvas.translate(position.dx, position.dy);
      canvas.rotate(angle);
      canvas.translate(-position.dx, -position.dy);
      textPainter.paint(canvas, delta);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}
