import 'package:flutter/material.dart';

class Moon extends StatelessWidget {
  const Moon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
    );
  }
}
