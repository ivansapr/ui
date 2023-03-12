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

  late String value;

  @override
  void initState() {
    super.initState();
    value = widget.value;
    _textEditingController = TextEditingController(text: value);
    _textEditingController.addListener(() {
      setState(() {
        value = _textEditingController.text;
      });
    });
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white, border: Border.all(width: 3)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: value.toUpperCase().split('').map((e) => _JumpingLetter(char: e)).toList(),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 100,
            child: TextField(
              controller: _textEditingController,
            ),
          ),
        ],
      ),
    );
  }
}

class _JumpingLetter extends StatefulWidget {
  final String char;
  const _JumpingLetter({required this.char});

  @override
  State<_JumpingLetter> createState() => _JumpingLetterState();
}

class _JumpingLetterState extends State<_JumpingLetter> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _animation;
  late Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    final r = Random();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500 + 10 * r.nextInt(10)),
    );
    _animation = Tween<double>(begin: 0, end: 1)
        .animate(CurveTween(curve: Curves.bounceOut).animate(_controller));
    _rotation = Tween<double>(begin: 1 + (r.nextBool() ? 0.2 : -0.2), end: 1)
        .animate(CurveTween(curve: Curves.bounceOut).animate(_controller));

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant _JumpingLetter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.char != oldWidget.char) {
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _rotation,
      filterQuality: FilterQuality.low,
      child: ScaleTransition(
        scale: _animation,
        child: Text(widget.char),
      ),
    );
  }
}
