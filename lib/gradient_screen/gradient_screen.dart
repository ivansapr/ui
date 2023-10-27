import 'package:flutter/material.dart';

class GradientScreen extends StatefulWidget {
  const GradientScreen({Key? key}) : super(key: key);

  @override
  State<GradientScreen> createState() => _GradientScreenState();
}

class _GradientScreenState extends State<GradientScreen> {
  final GlobalKey key = GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Colors.blue,
            Colors.red.shade500,
          ],
          radius: 1.5,
          focal: const Alignment(1, 1),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SmallButtonWidget(
            key: key,
            onPressed: () {
              final box = key.currentContext!.findRenderObject() as RenderBox;
              final position = box.localToGlobal(Offset.zero);
              final size = box.size;
              Navigator.of(context).push(
                CustomTransition(
                  child: OpenedButtonPage(
                    position: position,
                    size: size,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class SmallButtonWidget extends StatelessWidget {
  final void Function() onPressed;

  const SmallButtonWidget({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (_) {
        onPressed();
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: ShapeDecoration(
          color: Colors.grey.shade300,
          shadows: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.elliptical(12, 12),
            ),
          ),
        ),
        child: const Icon(Icons.people_alt_outlined),
      ),
    );
  }
}

class OpenedButtonPage extends StatelessWidget {
  final Offset position;
  final Size size;

  const OpenedButtonPage({
    Key? key,
    required this.position,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Navigator.of(context).pop,
      child: Container(
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned(
              top: position.dy - 20,
              left: position.dx - 100 + size.width / 2,
              child: const FractionalTranslation(
                translation: Offset(0, -1),
                child: SelectorColumn(),
              ),
            ),
            Positioned(
              top: position.dy,
              left: position.dx,
              child: Transform.scale(
                scale: 1.2,
                child: SmallButtonWidget(
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTransition extends PageRouteBuilder {
  final Widget child;

  CustomTransition({required this.child})
      : super(
          transitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeIn,
                ),
              ),
              child: child,
            );
          },
          pageBuilder: (context, animation, secondaryAnimation) {
            return child;
          },
          fullscreenDialog: true,
          barrierColor: Colors.transparent,
          opaque: false,
        );
}

class SelectorColumn extends StatelessWidget {
  const SelectorColumn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListView.separated(
          itemCount: 4,
          shrinkWrap: true,
          padding: const EdgeInsets.all(0),
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => Container(
            padding: const EdgeInsets.all(8),
            // color: Colors.white,
            child: Listener(
              onPointerSignal: (_) {
                print('Signal $index');
              },
              onPointerMove: (_) {
                print('move $index');
              },
              onPointerHover: (_) {
                print('Hover $index');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('Item $index'), const Icon(Icons.join_full)],
              ),
            ),
          ),
          separatorBuilder: (context, index) => const Divider(height: 1),
        ),
      ),
    );
  }
}
