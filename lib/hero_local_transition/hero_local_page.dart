import 'dart:math';

import 'package:bezier/bezier.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' show Vector2;

class HeroLocalPage extends StatefulWidget {
  const HeroLocalPage({Key? key}) : super(key: key);

  @override
  State<HeroLocalPage> createState() => _HeroLocalPageState();
}

class _HeroLocalPageState extends State<HeroLocalPage> {
  final tags = <int>{1, 2, 3, 5, 10};

  final keyTo = GlobalKey();

  int sum = 0;

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

  void addOverlay(GlobalKey fromKey, int value) {
    final from = fromKey.currentContext!.findRenderObject() as RenderBox;
    final destination = keyTo.currentContext!.findRenderObject() as RenderBox;

    final fromCenterPosition = from.localToGlobal(from.size.bottomCenter(Offset.zero));
    final destinationCenterPosition =
        destination.localToGlobal(destination.size.topCenter(Offset.zero));
    final path = createPath(fromCenterPosition, destinationCenterPosition);

    final distance = (destinationCenterPosition - fromCenterPosition).distanceSquared;
    const duration = Duration(milliseconds: 2000);

    final overlayEntry = OverlayEntry(
      opaque: false,
      builder: (context) {
        return Positioned(
          top: 0,
          left: 0,
          child: TweenAnimationBuilder<double>(
            duration: duration,
            curve: Curves.easeInOut,
            tween: Tween(begin: 0, end: 1),
            builder: (context, value, child) {
              final point = path.pointAt(value);
              return Transform.translate(
                offset: point.toOffset() - const Offset(10, 0),
                child: Transform.scale(
                  scale: 1 - value * 0.5,
                  child: child,
                ),
              );
            },
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                padding: const EdgeInsets.all(10),
                height: 20,
                width: 20,
                decoration: const BoxDecoration(
                  color: Colors.yellow,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '\$',
                    style: DefaultTextStyle.of(context).style.copyWith(
                          color: Colors.amber,
                          fontSize: 15,
                        ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context, debugRequiredFor: widget).insert(overlayEntry);
    Future.delayed(duration, () {
      overlayEntry.remove();
      setState(() {
        sum += value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.black12,
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: tags.map(
                  (e) {
                    final key = GlobalKey();
                    return InputChip(
                      key: key,
                      onPressed: () {
                        addOverlay(key, e);
                      },
                      label: Text('+$e'),
                      backgroundColor: Colors.green,
                    );
                  },
                ).toList(),
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              height: 200,
              width: 100,
              child: MovableWidget(
                child: AnimatedSum(
                  key: keyTo,
                  value: sum,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedSum extends StatefulWidget {
  final int value;

  const AnimatedSum({Key? key, required this.value}) : super(key: key);

  @override
  State<AnimatedSum> createState() => _AnimatedSumState();
}

class _AnimatedSumState extends State<AnimatedSum> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 100),
    );
    _animation = Tween<double>(
      begin: 1,
      end: 1.2,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutQuad,
      ),
    );

    runBounce();
  }

  Future<void> runBounce() async {
    await _controller.forward();
    await _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Chip(
        label: Text(widget.value.toString()),
      ),
    );
  }

  @override
  void didUpdateWidget(AnimatedSum oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      runBounce();
    }
  }
}

class MovableWidget extends StatefulWidget {
  final Widget child;

  const MovableWidget({Key? key, required this.child}) : super(key: key);

  @override
  State<MovableWidget> createState() => _MovableWidgetState();
}

class _MovableWidgetState extends State<MovableWidget> {
  var offset = Offset.zero;
  var key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        final newOffset = offset + details.delta;
        final child = key.currentContext!.findRenderObject() as RenderBox;
        final childSize = child.size.bottomRight(Offset.zero);
        final parentSize = context.size!.bottomRight(Offset.zero);
        setState(() {
          offset = newOffset.abs().border(parentSize - childSize);
        });
      },
      child: Container(
        color: Colors.blue,
        child: Stack(
          children: [
            Positioned(
              top: offset.dy,
              left: offset.dx,
              child: KeyedSubtree(
                key: key,
                child: widget.child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension _OffsetToVector2 on Offset {
  Vector2 toVector2() => Vector2(dx, dy);

  Offset abs() => Offset(dx.abs(), dy.abs());

  Offset border(Offset other) => Offset(min(dx, other.dx), min(dy, other.dy));
}

extension _Vector2ToOffset on Vector2 {
  Offset toOffset() => Offset(x, y);
}
