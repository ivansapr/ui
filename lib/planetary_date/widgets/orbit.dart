import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class Orbit extends StatelessWidget {
  final double angle;
  final int radius;
  final Widget satelite;
  final Widget main;

  final int sateliteRadius;

  const Orbit({
    Key? key,
    required this.satelite,
    required this.angle,
    required this.radius,
    required this.main,
    required this.sateliteRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Transform.rotate(
          angle: angle,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: DottedBorder(
                  borderPadding: EdgeInsets.all(sateliteRadius.toDouble()),
                  dashPattern: const [4, 4],
                  borderType: BorderType.Oval,
                  color: Colors.grey.shade600,
                  child: SizedBox.square(
                    dimension: radius * 2,
                  ),
                ),
              ),
              satelite,
            ],
          ),
        ),
        main,
      ],
    );
  }
}
