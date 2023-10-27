import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class AnimatedSwitchIconsPage extends StatefulWidget {
  const AnimatedSwitchIconsPage({super.key});

  @override
  State<AnimatedSwitchIconsPage> createState() => _AnimatedSwitchIconsPageState();
}

class _AnimatedSwitchIconsPageState extends State<AnimatedSwitchIconsPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ChangeStateWidget(),
          MovingWidget(),
          RotationChangeWidget(),
        ],
      ),
    );
  }
}

class MovingWidget extends StatefulWidget {
  const MovingWidget({super.key});

  @override
  State<MovingWidget> createState() => _MovingWidgetState();
}

class _MovingWidgetState extends State<MovingWidget> with SingleTickerProviderStateMixin {
  bool state = false;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 250),
    vsync: this,
  );
  late final Animation<Alignment> _animation = AlignmentTween(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ).animate(
    CurvedAnimation(parent: _controller, curve: Curves.bounceInOut),
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.isCompleted ? _controller.reverse() : _controller.forward();
      },
      child: Container(
        height: 200,
        width: 100,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black),
        ),
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Align(
              alignment: _animation.value,
              child: DefaultTextStyle(
                  style: DefaultTextStyle.of(context).style.copyWith(
                        foreground: Paint()
                          ..style = PaintingStyle.fill
                          ..color = Colors.black
                          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1),
                      ),
                  child: child!),
            );
          },
          child: const Text('Hello'),
        ),
      ),
    );
  }
}

class CustomBlurTextPainter extends CustomPainter {
  final String text;
  final TextStyle textStyle;

  CustomBlurTextPainter({
    required this.textStyle,
    required this.text,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final textSpan = TextSpan(
      text: text,
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout(
        minWidth: 0,
        maxWidth: size.width,
      );

    final blurPaint = Paint()..maskFilter = MaskFilter.blur(BlurStyle.normal, 1);
    textPainter.paint(canvas, Offset.zero);
    canvas.drawRect(
        Rect.fromPoints(Offset.zero, Offset(size.width, textStyle.fontSize!)), blurPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ChangeStateWidget extends StatefulWidget {
  const ChangeStateWidget({super.key});

  @override
  State<ChangeStateWidget> createState() => _ChangeStateWidgetState();
}

class _ChangeStateWidgetState extends State<ChangeStateWidget> {
  bool state = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          setState(() {
            state = !state;
          });
        },
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: animation,
                child: child,
              ),
            );
          },
          child: state
              ? const Icon(
                  Icons.mail,
                  key: ValueKey(1),
                )
              : const Icon(
                  Icons.mail_outline,
                  key: ValueKey(2),
                ),
        ),
      ),
    );
  }
}

class RotationChangeWidget extends StatefulWidget {
  const RotationChangeWidget({super.key});

  @override
  State<RotationChangeWidget> createState() => _RotationChangeWidgetState();
}

class _RotationChangeWidgetState extends State<RotationChangeWidget>
    with SingleTickerProviderStateMixin {
  bool state = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          setState(() {
            state = !state;
          });
        },
        child: Container(
          color: Colors.green,
          child: AnimatedSwitcher(
            duration: const Duration(seconds: 2),
            transitionBuilder: (child, animation) {
              final s = TweenSequence(
                [
                  TweenSequenceItem(
                    tween: Tween<Offset>(
                      begin: Offset.zero,
                      end: const Offset(1, 0),
                    ),
                    weight: 1,
                  ),
                  TweenSequenceItem(
                    tween: Tween<Offset>(
                      begin: const Offset(1, 0),
                      end: const Offset(1, 1),
                    ),
                    weight: 1,
                  ),
                  TweenSequenceItem(
                    tween: Tween<Offset>(
                      begin: const Offset(1, 1),
                      end: const Offset(0, 1),
                    ),
                    weight: 1,
                  ),
                  TweenSequenceItem(
                    tween: Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: const Offset(0, 0),
                    ),
                    weight: 1,
                  ),
                ],
              );

              return SlideTransition(
                position: s.animate(animation),
                child: child,
              );
            },
            child: state
                ? const Icon(Icons.mail, key: ValueKey(1))
                : const Icon(Icons.mail_outline, key: ValueKey(2)),
          ),
        ),
      ),
    );
  }
}
