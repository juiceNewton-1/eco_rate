import 'package:flutter/material.dart';

class CircleIndicator extends CustomPainter {
  final Color fillColor;
  final double fillValue;
  final double? divisionValue;

  CircleIndicator(
      {required this.fillColor, required this.fillValue, this.divisionValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    const strokeWidth = 10.0;
    const remainingColor = Colors.grey;

    // Рисуем незаполненную окружность
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = remainingColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    // Рисуем заполняющуюся часть окружности
    final progressPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final progressAngle = 2 *
        3.14 *
        (divisionValue != null
            ? fillValue / divisionValue!
            : fillValue); // Рассчитываем угол прогресса
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14 / 2, // Начинаем рисовать с верхней точки
      progressAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
