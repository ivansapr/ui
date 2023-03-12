import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

const _textColor = Colors.white;
const _itemTextColor = Colors.grey;
const _selectedColor = Color.fromRGBO(53, 99, 216, 1);
const _hoverColor = Color.fromRGBO(25, 31, 36, 1);
const _buttonBackgroundColor = Color.fromRGBO(27, 31, 36, 1);
const _buttonColor = Color.fromRGBO(10, 11, 13, 1);

final _radius = [
  BorderRadius.circular(20),
  BorderRadius.circular(16),
  BorderRadius.circular(13),
  BorderRadius.circular(13),
  BorderRadius.circular(13),
];

class CustomDropDown extends StatefulWidget {
  const CustomDropDown({super.key});

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _gradientAnimation;
  late Animation<double> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this)
      ..addListener(() {
        setState(() {});
      });
    _gradientAnimation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _colorAnimation = Tween<double>(begin: -1, end: 1).animate(_animationController);
  }

  void animate() {
    _animationController
        .animateTo(
          1,
          duration: Duration(seconds: 2),
          curve: Curves.easeInOut,
        )
        .then((value) => _animationController.reset());
  }

  bool opened = true;

  void onTap(bool value) {
    setState(() {
      opened = value;
    });
    if (opened) {
      animate();
    } else {
      _animationController
          .animateTo(1, duration: Duration(milliseconds: 100))
          .then((value) => _animationController.reset());
    }
  }

  Widget _itemsList() {
    return _ItemsList(
      items: [
        _Item(value: 'item1'),
        _Item(value: 'item2'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => onTap(true),
      onExit: (event) => onTap(false),
      child: Container(
        width: 200,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: _buttonColor,
          borderRadius: _radius[0],
          gradient: SweepGradient(
            colors: [
              _buttonColor,
              Color.lerp(_selectedColor, _buttonColor, _colorAnimation.value.abs()) ?? _buttonColor,
              _buttonColor,
            ],
            startAngle: 3 * math.pi / 2,
            endAngle: 2 * math.pi,
            transform: GradientRotation(_gradientAnimation.value),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: _buttonColor,
            borderRadius: _radius[0],
          ),
          padding: const EdgeInsets.all(3.0),
          child: Container(
            decoration: BoxDecoration(
              color: _buttonColor,
              borderRadius: _radius[1],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Header(
                  selected: opened,
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  child: opened ? _itemsList() : Container(),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SizeTransition(
                      sizeFactor: animation,
                      child: child,
                    ),
                  ),
                  layoutBuilder: (currentChild, previousChildren) {
                    return Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        if (currentChild != null) currentChild,
                        ...previousChildren,
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final bool selected;

  const _Header({
    super.key,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 10),
      decoration: BoxDecoration(
        color: _buttonBackgroundColor,
        borderRadius: _radius[2],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Select value...',
            style: DefaultTextStyle.of(context).style.copyWith(
                  color: _textColor,
                ),
          ),
          _AnimatedIcon(
            Icons.unfold_more_rounded,
            color: selected ? _selectedColor : _textColor,
            duration: Duration(milliseconds: 150),
          )
        ],
      ),
    );
  }
}

class _Item extends StatefulWidget {
  final String value;
  const _Item({super.key, required this.value});

  @override
  State<_Item> createState() => _ItemState();
}

class _ItemState extends State<_Item> {
  bool hover = false;

  void onHover() {
    setState(() {
      hover = !hover;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() {
        hover = true;
      }),
      onExit: (_) => setState(() {
        hover = false;
      }),
      cursor: MaterialStateMouseCursor.clickable,
      child: AnimatedContainer(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          color: hover ? _hoverColor : _buttonColor,
          borderRadius: _radius[3],
        ),
        child: AnimatedDefaultTextStyle(
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 200),
          style: DefaultTextStyle.of(context).style.copyWith(
                color: hover ? _selectedColor : _itemTextColor,
              ),
          child: Text(widget.value),
        ),
      ),
    );
  }
}

class _ItemsList extends StatefulWidget {
  final List<Widget> items;
  const _ItemsList({super.key, required this.items});

  @override
  State<_ItemsList> createState() => _ItemsListState();
}

class _ItemsListState extends State<_ItemsList> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideTransition;
  late Animation<double> _opacityTransition;

  @override
  void initState() {
    super.initState();
    print('initState');
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _slideTransition = Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _opacityTransition = Tween<double>(begin: 0, end: 1).animate(_animationController);

    startAnimation();
  }

  Future<void> startAnimation() async {
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityTransition,
      child: SlideTransition(
        position: _slideTransition,
        child: ListView.separated(
          padding: EdgeInsets.only(top: 5),
          shrinkWrap: true,
          itemCount: widget.items.length,
          separatorBuilder: (context, index) => SizedBox(height: 5),
          itemBuilder: (context, index) {
            final item = widget.items[index];
            return HoverAnimation(child: item);
          },
        ),
      ),
    );
  }
}

class HoverAnimation extends StatelessWidget {
  final Widget child;
  const HoverAnimation({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 1, end: 0),
      duration: Duration(milliseconds: 500),
      builder: (context, value, child) => Container(
        foregroundDecoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3 * value),
          borderRadius: _radius[3],
        ),
        child: child,
      ),
      child: child,
    );
  }
}

class _AnimatedIcon extends StatefulWidget {
  final Color color;
  final Duration duration;
  const _AnimatedIcon(
    this.icon, {
    super.key,
    required this.color,
    required this.duration,
  });

  final IconData icon;

  @override
  State<_AnimatedIcon> createState() => _AnimatedIconState();
}

class _AnimatedIconState extends State<_AnimatedIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animation;
  late Color color;
  Color? newColor;

  Color? animatedColor;

  @override
  void initState() {
    super.initState();
    color = widget.color;
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..addListener(() => setState(() {}));
    _animation = ColorTween(begin: color, end: color).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant _AnimatedIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    color = widget.color;
    if (oldWidget.color != widget.color) {
      _animation = ColorTween(begin: oldWidget.color, end: color).animate(_controller);
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      widget.icon,
      color: _animation.value,
    );
  }
}
