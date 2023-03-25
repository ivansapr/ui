import 'package:flutter/material.dart';
import 'package:ui_exp/align_buttons_row/effects/tap.dart';

const _lineWidth = 20.0;
const _lineHeight = 3.0;
const _lineGap = 4.0;

class AlignButtons extends StatefulWidget {
  const AlignButtons({Key? key}) : super(key: key);

  @override
  State<AlignButtons> createState() => _AlignButtonsState();
}

class _AlignButtonsState extends State<AlignButtons> {
  late CrossAxisAlignment _crossAxisAlignment;

  @override
  void initState() {
    super.initState();
    _crossAxisAlignment = CrossAxisAlignment.center;
  }

  void setCrossAxisAlignment(CrossAxisAlignment value) {
    setState(() {
      _crossAxisAlignment = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: TapEffect(
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AlignButton(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      onTap: setCrossAxisAlignment,
                    ),
                    AlignButton(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      onTap: setCrossAxisAlignment,
                    ),
                    AlignButton(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      onTap: setCrossAxisAlignment,
                    ),
                  ],
                ),
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AnimatedAlignLines(
                        alignment: _crossAxisAlignment,
                        duration: Duration.zero,
                      ),
                      AnimatedAlignLines(
                        alignment: _crossAxisAlignment,
                        duration: const Duration(milliseconds: 100),
                      ),
                      AnimatedAlignLines(
                        alignment: _crossAxisAlignment,
                        isShort: true,
                        duration: const Duration(milliseconds: 200),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedAlignLines extends StatefulWidget {
  final CrossAxisAlignment alignment;
  final Duration duration;
  final bool isShort;

  const AnimatedAlignLines({
    Key? key,
    required this.alignment,
    required this.duration,
    this.isShort = false,
  }) : super(key: key);

  @override
  State<AnimatedAlignLines> createState() => _AnimatedAlignLinesState();
}

class _AnimatedAlignLinesState extends State<AnimatedAlignLines>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<AlignmentGeometry?> _tween;

  AlignmentGeometry alignment = Alignment.center;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(() {
        setState(() {
          alignment = _tween.value ?? Alignment.center;
        });
      });
  }

  @override
  void didUpdateWidget(covariant AnimatedAlignLines oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.alignment != widget.alignment) {
      final newAlign = _alignment(widget.alignment);

      Future.delayed(widget.duration, () {
        _tween = AlignmentGeometryTween(
          begin: alignment,
          end: newAlign,
        ).chain(CurveTween(curve: Curves.easeInOut)).animate(_controller);
        _controller.forward(from: 0);
      });
    }
  }

  Alignment _alignment(CrossAxisAlignment alignment) {
    switch (alignment) {
      case CrossAxisAlignment.start:
        return Alignment.centerLeft;
      case CrossAxisAlignment.center:
        return Alignment.center;
      case CrossAxisAlignment.end:
      default:
        return Alignment.centerRight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: _Line(
        short: widget.isShort,
        color: Colors.black,
      ),
    );
  }
}

class AlignButton extends StatelessWidget {
  final CrossAxisAlignment crossAxisAlignment;
  final Color color;
  final void Function(CrossAxisAlignment) onTap;

  const AlignButton({
    Key? key,
    required this.crossAxisAlignment,
    this.color = Colors.grey,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onTap(crossAxisAlignment),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          _Line(color: color),
          const SizedBox(height: _lineGap),
          _Line(color: color),
          const SizedBox(height: _lineGap),
          _Line(short: true, color: color),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  final Color color;
  final bool short;
  const _Line({
    super.key,
    required this.color,
    this.short = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _lineHeight,
      width: short ? _lineWidth / 2 : _lineWidth,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
