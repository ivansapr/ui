import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

const _size = Size(200, 200);

class ShaderPage extends StatelessWidget {
  const ShaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Wrap(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // ShaderWidget(assetKey: 'shaders/simple.frag'),
            ShaderWidget(assetKey: 'shaders/ripple.frag'),
            const Block(),
            ShaderMask(
              blendMode: BlendMode.difference,
              shaderCallback: (bounds) {
                return ui.Gradient.radial(
                  const Offset(50, 50),
                  50,
                  <Color>[
                    Colors.red,
                    Colors.green,
                    Colors.blue,
                    Colors.red,
                  ],
                  <double>[
                    0.0,
                    0.5,
                    0.75,
                    1.0,
                  ],
                );
              },
              child: const Block(),
            ),
          ],
        ),
      ),
    );
  }
}

class ShaderWidget extends StatelessWidget {
  final String assetKey;

  ShaderWidget({super.key, required this.assetKey});

  final DateTime _startTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder(
      (context, shader, child) {
        return AnimatedSampler(
          (image, size, canvas) {
            shader
              ..setFloat(0, size.width)
              ..setFloat(1, size.height)
              ..setFloat(2, _startTime.difference(DateTime.now()).inMilliseconds / 1000)
              ..setImageSampler(0, image);

            canvas.drawRect(
              Offset.zero & size,
              Paint()..shader = shader,
            );
          },
          child: child!,
        );
      },
      assetKey: assetKey,
      child: const Block(),
    );
  }
}

class Block extends StatefulWidget {
  const Block({super.key});

  @override
  State<Block> createState() => _BlockState();
}

class _BlockState extends State<Block> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  late final Animation<Alignment> _animation;

  @override
  void initState() {
    super.initState();
    _animation = Tween<Alignment>(begin: Alignment.centerLeft, end: Alignment.centerRight).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: _size,
      child: Stack(
        children: [
          Container(
            width: _size.width,
            height: _size.height,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                tileMode: TileMode.repeated,
                colors: List.generate(10, (index) => index.isEven ? Colors.white : Colors.black),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 30,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class ShaderPainter extends CustomPainter {
  ShaderPainter({required this.shader});

  ui.FragmentShader shader;

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);

    final paint = Paint()..shader = shader;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
