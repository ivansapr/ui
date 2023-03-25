import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';

class TapEffect extends StatefulWidget {
  const TapEffect({super.key, required this.child});

  final Widget child;

  @override
  State<TapEffect> createState() => _TapEffectState();
}

class _TapEffectState extends State<TapEffect> {
  var scale = 1.0;

  void onTap() {
    setState(() {
      scale = 0.95;
    });
    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        scale = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => onTap(),
      child: AnimatedScale(
        scale: scale,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: widget.child,
      ),
    );
  }
}
