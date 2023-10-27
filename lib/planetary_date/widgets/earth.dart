import 'package:flutter/material.dart';
import 'package:ui_exp/planetary_date/widgets/effects/pulse.dart';

class Earth extends StatelessWidget {
  const Earth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PulseEffect(
      color: Colors.white.withOpacity(.4),
      radius: 12,
      child: const CircleAvatar(
        radius: 12,
        backgroundColor: Color(0xFF0B880B),
      ),
    );
  }
}
