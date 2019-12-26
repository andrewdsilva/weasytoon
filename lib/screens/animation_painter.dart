import 'package:flutter/material.dart';
import 'dart:ui';

class AnimationPainter extends CustomPainter {

  final offsets;

  AnimationPainter(this.offsets): super();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
    ..color = Colors.black
    ..isAntiAlias = true
    ..strokeWidth = 3.0
    ..strokeCap = StrokeCap.round;

    var rect = Offset.zero & size;
    canvas.clipRect(rect);

    for (var i = 0; i < offsets.length - 1; i++) {
      if (offsets[i] != null && offsets[i + 1] != null) {
        canvas.drawLine(
          offsets[i],
          offsets[i + 1],
          paint
        );
      } else if (offsets[i] != null && offsets[i + 1] == null) {
        canvas.drawPoints(
          PointMode.points,
          [offsets[i]],
          paint
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

}
