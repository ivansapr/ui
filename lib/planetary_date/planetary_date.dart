import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:ui_exp/planetary_date/widgets/earth.dart';
import 'package:ui_exp/planetary_date/widgets/mood.dart';
import 'package:ui_exp/planetary_date/widgets/orbit.dart';
import 'package:ui_exp/planetary_date/widgets/space.dart';
import 'package:ui_exp/planetary_date/widgets/sun.dart';

class PlanetaryDate extends StatefulWidget {
  const PlanetaryDate({Key? key}) : super(key: key);

  @override
  State<PlanetaryDate> createState() => _PlanetaryDateState();
}

class _PlanetaryDateState extends State<PlanetaryDate> with SingleTickerProviderStateMixin {
  late GlobalKey _centerKey;
  double angle = 0;
  double velocity = 0;

  late final AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _centerKey = GlobalKey();
    animationController = AnimationController(vsync: this, duration: const Duration(seconds: 10))
      ..addListener(() {
        setState(() {
          angle = animation.value;
        });
      });
  }

  void globalPositionToAngle(Offset globalPosition) {
    final RenderBox renderBox = _centerKey.currentContext?.findRenderObject() as RenderBox;

    final localPosition = renderBox.globalToLocal(globalPosition);
    final center = renderBox.size.center(Offset.zero);
    final dx = center.dx - localPosition.dx;
    final dy = center.dy - localPosition.dy;
    final angle = math.atan2(dy, dx);
    setState(() {
      this.angle = angle + 3 * math.pi / 2;
    });
  }

  void onPanStart(DragStartDetails details) {
    animationController.stop();
  }

  void onPanUpdate(DragUpdateDetails details) {
    globalPositionToAngle(details.globalPosition);
  }

  void onPanEnd(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond;
    physics(velocity);
  }

  bool getCircularDirection(Offset globalPosition) {
    final RenderBox renderBox = _centerKey.currentContext?.findRenderObject() as RenderBox;

    final localPosition = renderBox.globalToLocal(globalPosition);
    final center = renderBox.size.center(Offset.zero);
    final dx = center.dx - localPosition.dx;
    final dy = center.dy - localPosition.dy;
    final angle = math.atan2(dy, dx);
    final direction = angle + math.pi / 2;
    return direction > 0;
  }

  void physics(Offset pixelsPerSecond) {
    final renderBox = _centerKey.currentContext?.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance / 2;

    final simulation = FrictionSimulation(0.1, angle, unitVelocity);

    final endAngle = simulation.dx(1);

    animation = animationController.drive(Tween(begin: angle, end: angle + endAngle));
    animationController.animateWith(simulation);
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DefaultTextStyle(
          style: DefaultTextStyle.of(context).style.copyWith(
                color: Colors.white,
              ),
          child: Text(angle.toStringAsFixed(2)),
        ),
        SpaceCard(
          size: const Size(350, 350),
          child: Orbit(
            key: _centerKey,
            angle: angle,
            radius: 150,
            sateliteRadius: 30,
            main: const Sun(),
            satelite: Orbit(
              angle: angle * 12,
              radius: 30,
              sateliteRadius: 0,
              satelite: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Moon(),
              ),
              main: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onPanStart: onPanStart,
                  onPanUpdate: onPanUpdate,
                  onPanEnd: onPanEnd,
                  child: const Earth(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
