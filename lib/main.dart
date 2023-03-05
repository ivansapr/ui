import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ui_exp/rolling_numbers_widget.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int numbers = 12345;

  @override
  void initState() {
    super.initState();
    final r = Random();
    numbers = 1;//r.nextInt(1);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: () {
          setState(() {
            numbers += 1;
          });
        }),
        body: Center(
          child: Column(
            children: [RollingNumbers(numbers: numbers), Text(numbers.toString())],
          ),
        ),
      ),
    );
  }
}
