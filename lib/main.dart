import 'package:flutter/material.dart';
import 'package:ui_exp/drop_down.dart';
import 'package:ui_exp/following_letters.dart';

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
      home: FollowingLetters(
        body: Scaffold(
          backgroundColor: const Color.fromRGBO(27, 31, 36, 1),
          body: Padding(
            padding: const EdgeInsets.only(top: 200),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  // Row(
                  //   mainAxisSize: MainAxisSize.min,
                  //   children: [
                  //     RollingNumbers(numbers: numbers),
                  //     TextButton(
                  //         onPressed: () {
                  //           setState(() {
                  //             final r = Random();
                  //             numbers = r.nextInt(9999);
                  //           });
                  //         },
                  //         child: Text('Random')),
                  //     TextButton(
                  //         onPressed: () {
                  //           setState(() {
                  //             numbers += 1;
                  //           });
                  //         },
                  //         child: Text('+1')),
                  //   ],
                  // ),
                  // SizedBox(height: 10),
                  // Row(
                  //   mainAxisSize: MainAxisSize.min,
                  //   children: [
                  //     JumpingLetters(value: 'Ivan'),
                  //   ],
                  // ),
                  // SizedBox(height: 10),
                  CustomDropDown(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
