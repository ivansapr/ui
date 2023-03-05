import 'package:flutter/material.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';

class RollingNumbers extends StatelessWidget {
  final int numbers;
  const RollingNumbers({super.key, required this.numbers});

  List<int> _rowOfNumbers() {
    return numbers.toString().split('').map(int.parse).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(50),
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
            colors: [
              Colors.black,
              Colors.black.withOpacity(0),
              Colors.black.withOpacity(0),
              Colors.black,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [
              0,
              0.4,
              0.6,
              1,
            ]),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _rowOfNumbers().map((e) => _NumberWidget(number: e)).toList(),
      ),
    );
  }
}

class _NumberWidget extends StatefulWidget {
  final int number;
  const _NumberWidget({super.key, required this.number});

  @override
  State<_NumberWidget> createState() => _NumberWidgetState();
}

class _NumberWidgetState extends State<_NumberWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late final List<String> numbers;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    numbers = List.generate(widget.number + 1, (index) => index.toString());
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200 * numbers.length),
    );
    _animate();
  }

  void _animate() {
    _controller.reset();
    final endOffset = (numbers.length - 1) / numbers.length;
    _animation = Tween<Offset>(begin: Offset.zero, end: Offset(0, -1 * endOffset))
        .animate(CurveTween(curve: Curves.bounceOut).animate(_controller));

    _controller.animateTo(1, duration: Duration(milliseconds: 200 * numbers.length));
  }

  @override
  void didUpdateWidget(covariant _NumberWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final numbersList = List.generate(10, (index) => index.toString());
    final newNumebersList = numbersList.sublist(0,widget.number);

    final b = numbersList.sublist(oldWidget.number);
    // print(b);
    print(newNumebersList);

    numbers
      ..clear()
      ..addAll(b + newNumebersList);
    _animate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: DefaultTextStyle.of(context).style.copyWith(color: Colors.white, fontSize: 25),
      child: SizedBox(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Opacity(opacity: 0, child: Text('8')),
            ),
            Positioned(
              top: 0,
              child: SlideTransition(
                position: _animation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: numbers.map((e) => Text(e)).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
