import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter_shaders/flutter_shaders.dart';

class LinearProgress extends StatefulWidget {
  const LinearProgress({Key? key}) : super(key: key);

  @override
  State<LinearProgress> createState() => _LinearProgressState();
}

class _LinearProgressState extends State<LinearProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });
    // _controller.repeat();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          height: 100,
          width: 400,
          child: AnimatedBuilder(
              animation: _controller,
              builder: (context, snapshot) {
                return ShaderBuilder(
                  assetKey: 'shaders/simple.frag',
                  (context, shader, child) {
                    return CustomPaint(
                      size: MediaQuery.of(context).size,
                      painter: ShaderPainter(
                        shader: shader,
                        value: _controller.value,
                      ),
                      child: child,
                    );
                  },
                  child: const Center(
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}

class ShaderPainter extends CustomPainter {
  ShaderPainter({required this.shader, required this.value});
  ui.FragmentShader shader;

  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, value);
    shader.setFloat(1, size.height);
    shader.setFloat(2, size.width);

    final paint = Paint()..shader = shader;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant ShaderPainter oldDelegate) {
    return oldDelegate.value != value;
  }
}