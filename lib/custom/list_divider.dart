import 'package:flutter/material.dart';

class FancyLine extends StatelessWidget {
  final double width;
  final Color color;

  const FancyLine({
    Key? key,
    required this.width,
    this.color = Colors.teal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      child: CustomPaint(
        painter: FancyLinePainter(
          width: this.width,
          color: this.color,
        ),
      ),
    );
  }
}

class FancyLinePainter extends CustomPainter {
  final double width;
  final Color color;

  const FancyLinePainter({required this.width, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, 0);
    path.quadraticBezierTo(width / 2, 0.5, width, 0);
    path.quadraticBezierTo(width / 2, -0.5, 0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
