import 'package:flutter/rendering.dart';

class StripedProgressPainter extends CustomPainter {
  final Color stripeColor;
  final double stripeWidth;
  final double progress;

  StripedProgressPainter({
    required this.stripeColor,
    required this.stripeWidth,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = stripeColor
      ..strokeWidth = stripeWidth
      ..style = PaintingStyle.stroke
      ..strokeWidth=10
      ;

    final path = Path();
    final dx = progress * size.width;
    for (var x = -dx; x <= progress * 350; x += stripeWidth * 2) {
      path.moveTo(x, 22);
      path.lineTo(x + stripeWidth, 0);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
