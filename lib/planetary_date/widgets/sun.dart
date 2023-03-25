import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ui_exp/planetary_date/widgets/effects/pulse.dart';

class Sun extends StatelessWidget {
  const Sun({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PulseEffect(
      color: const Color(0xFFE6B800),
      radius: 20,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: const Color(0xFFE6B800),
      ),
    );
  }
}
