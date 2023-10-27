import 'package:flutter/material.dart';
import 'package:ui_exp/hero_transition/default_widget.dart';

class SecondPage extends StatelessWidget {
  final int index;

  const SecondPage({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Hero(
            tag: 'hero$index',
            child: const CoolWidget(),
          ),
        ),
      ),
    );
  }
}
