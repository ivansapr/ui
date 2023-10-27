import 'package:flutter/material.dart';
import 'package:ui_exp/infinite_render/infinite_render.dart';

class InfinitePage extends StatefulWidget {
  const InfinitePage({super.key});

  @override
  State<InfinitePage> createState() => _InfinitePageState();
}

class _InfinitePageState extends State<InfinitePage> {
  final text = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
          'Sed non risus. Suspendisse lectus tortor, dignissim sit amet, '
          'adipiscing nec, ultricies sed, dolor. Cras elementum ultrices diam. '
          'Maecenas ligula massa, varius a, semper congue, euismod non, mi. '
          'Proin porttitor, orci nec nonummy molestie, enim est eleifend mi, '
          'non fermentum diam nisl sit amet erat. Duis semper. Duis arcu massa, '
          'scelerisque vitae, consequat in, pretium a, enim. Pellentesque '
          'congue. Ut in risus volutpat libero pharetra tempor. Cras vestibulum '
          'bibendum augue. Praesent egestas leo in pede. Praesent blandit odio '
          'eu enim. Pellentesque sed dui ut augue blandit sodales. Vestibulum '
          'ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia '
          'Curae; Aliquam nibh. Mauris ac mauris sed pede pellentesque fermentum. '
          'Maecenas adipiscing ante non diam sodales hendrerit.'
      .replaceAll(' ', '');

  var _text = '';

  @override
  void initState() {
    super.initState();
    addLetter();
  }

  Future<void> addLetter() async {
    for (var i = 0; i < text.length; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        _text += text[i];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 400,
        height: 400,
        color: Colors.amberAccent,
        child: Center(
          child: CustomPaint(
            willChange: true,
            size: const Size(300, 300),
            painter: InfiniteRender(_text),
          ),
        ),
      ),
    );
  }
}
