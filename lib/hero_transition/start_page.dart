import 'package:flutter/material.dart';
import 'package:ui_exp/hero_transition/default_widget.dart';
import 'package:ui_exp/hero_transition/new_page.dart';

class HeroPage extends StatelessWidget {
  const HeroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) => GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 500),
                pageBuilder: (context, animation, secondaryAnimation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SecondPage(index: index),
                  );
                },
              ),
            );
          },
          child: Hero(
            tag: 'hero$index',
            // placeholderBuilder: (context, size, widget) => ,
            flightShuttleBuilder: (context, animation, direction, fromContext, toContext) {
              return RotationTransition(
                turns: animation,
                child: const CoolWidget(),
              );
            },
            child: const CoolWidget(),
          ),
        ),
        separatorBuilder: (context, index) => const SizedBox(height: 20),
      ),
    );
  }
}
