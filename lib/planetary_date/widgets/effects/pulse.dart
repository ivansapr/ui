import 'package:flutter/material.dart';

class PulseEffect extends StatelessWidget {
  final Widget child;
  final Color color;
  final int radius;

  const PulseEffect({
    Key? key,
    required this.child,
    required this.color,
    required this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _PulseEffectWidget(
          color: color,
          radius: radius,
        ),
        _PulseEffectWidget(
          color: color,
          delay: .33,
          radius: radius,
        ),
        _PulseEffectWidget(
          color: color,
          delay: .66,
          radius: radius,
        ),
        _PulseEffectWidget(
          color: color,
          delay: 1,
          radius: radius,
        ),
        child,
      ],
    );
  }
}

class _PulseEffectWidget extends StatefulWidget {
  const _PulseEffectWidget({Key? key, this.delay = 0, required this.color, required this.radius})
      : super(key: key);
  final double delay;
  final Color color;
  final int radius;

  @override
  _PulseEffectWidgetState createState() => _PulseEffectWidgetState();
}

class _PulseEffectWidgetState extends State<_PulseEffectWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  /// The animation that controls the size of the sun.
  late final Animation<double> _sizeAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      value: widget.delay,
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _sizeAnimation = Tween<double>(begin: .4, end: 2).animate(_controller);
    _fadeAnimation = Tween<double>(begin: .5, end: 0).animate(_controller);

    _controller.repeat(reverse: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _sizeAnimation,
        child: CircleAvatar(
          radius: widget.radius.toDouble(),
          backgroundColor: widget.color,
        ),
      ),
    );
  }
}
