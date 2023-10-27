import 'dart:math';

import 'package:flutter/material.dart';

class JumpingLetters extends StatefulWidget {
  final String value;
  const JumpingLetters({super.key, required this.value});

  @override
  State<JumpingLetters> createState() => _JumpingLettersState();
}

class _JumpingLettersState extends State<JumpingLetters> {
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: DefaultTextStyle.of(context).style.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
      child: Container(
        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white, border: Border.all(width: 3)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListenableBuilder(
              listenable: _textEditingController,
              builder: (context, _) {
                final selection = _textEditingController.value.selection;
                final characters = _textEditingController.text.toUpperCase().split('');
                final children = <Widget>[];
                for (var i = 0; i < characters.length; i++) {
                  final char = characters[i];
                  final child = _JumpingLetter(char: char, key: Key('$char-$i'));
                  children.add(child);
                }

                if (selection.isCollapsed && selection.baseOffset > -1) {
                  children.insert(
                      selection.baseOffset,
                      UnconstrainedBox(
                        child: Container(
                          width: 2,
                          height: 20,
                          color: Colors.blue,
                        ),
                      ));
                }
                return Focus(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: children,
                  ),
                );
              },
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 100,
              child: TextField(controller: _textEditingController),
            ),
          ],
        ),
      ),
    );
  }
}

class _JumpingLetter extends StatelessWidget {
  final String char;
  const _JumpingLetter({required this.char, super.key});

  @override
  Widget build(BuildContext context) {
    final r = Random();

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + 10 * r.nextInt(10)),
      builder: (context, animation, child) {
        final double angle = (r.nextBool() ? 0.2 : -0.2) * (1 - animation);
        return Transform.scale(
          scale: animation,
          child: Transform.rotate(
            angle: angle,
            child: child,
          ),
        );
      },
      curve: Curves.bounceOut,
      child: Text(char),
    );
  }
}
