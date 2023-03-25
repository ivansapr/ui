import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ui_exp/calendar_view/selection_calendar.dart';
import 'package:ui_exp/drop_down.dart';
import 'package:ui_exp/jumping_letters.dart';
import 'package:ui_exp/planetary_date/planetary_date.dart';
import 'package:ui_exp/rolling_numbers_widget.dart';
import 'package:ui_exp/show_widget.dart';

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

    numbers = 12345;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromRGBO(27, 31, 36, 1),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RollingNumbers(numbers: numbers),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton(
                            onPressed: () {
                              setState(() {
                                final r = Random();
                                numbers = r.nextInt(9999);
                              });
                            },
                            child: Text('Random')),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              numbers += 1;
                            });
                          },
                          child: Text('+1'),
                        ),
                      ],
                    ),
                  ],
                ),

                // SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    JumpingLetters(value: 'Ivan'),
                  ],
                ),

                ShowWidget(
                  title: 'Animated Drop Down',
                  child: CustomDropDown(),
                ),
                ShowWidget(
                  title: 'Calendar with selectable range',
                  child: SelectionCalendar(),
                ),
                PlanetaryDate(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
