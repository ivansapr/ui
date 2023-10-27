import 'package:flutter/material.dart';

class ShowWidget extends StatelessWidget {
  final String title;
  final Widget child;

  const ShowWidget({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: child,
        ),
      ],
    );
  }
}
