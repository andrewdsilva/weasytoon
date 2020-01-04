import 'package:flutter/material.dart';
import 'dart:ui';

import '../models/frame.dart';
import '../services/animation_service.dart';

import 'dart:async';

class AnimationPainter extends CustomPainter {

  StreamSubscription<int> stateSubscription;

  Frame frame;
  double proportion = 1;
  bool onion        = true;
  Color background  = Colors.white;

  AnimationPainter(Frame frame, double proportion, bool onion, Color background) :
    this.frame        = frame,
    this.proportion   = proportion,
    this.onion        = onion,
    this.background   = background,
    stateSubscription = servAnimation.stateObservable.listen((int state) {
      // On change
    }),
    super();

  Offset adaptOffset(Offset o) {
    return o.scale(this.proportion, this.proportion);
  }

  double getStrokeWidth() {
    return 3.0 * this.proportion;
  }

  Paint getPaint() {
    return Paint()
      ..color = Colors.grey
      ..isAntiAlias = true
      ..strokeWidth = this.getStrokeWidth()
      ..strokeCap = StrokeCap.round;
  }

  Paint getEraser() {
    var eraser = this.getPaint();

    eraser.strokeWidth = this.getStrokeWidth() * 2;

    eraser.color = this.background;

    // eraser.color = Color(0x00000000);
    // eraser.blendMode = BlendMode.clear;

    return eraser;
  }

  void drawOffsets(canvas, offsets, paint) {
    var eraser = this.getEraser();

    for (var i = 0; i < offsets.length - 1; i++) {
      if (offsets[i] != null && offsets[i + 1] != null) {
        var paintTool = offsets[i].type == Tool.brush ? paint : eraser;

        canvas.drawLine(
          this.adaptOffset(offsets[i]),
          this.adaptOffset(offsets[i + 1]),
          paintTool
        );
      } else if (offsets[i] != null && offsets[i + 1] == null) {
        var paintTool = offsets[i].type == Tool.brush ? paint : eraser;

        canvas.drawPoints(
          PointMode.points,
          [this.adaptOffset(offsets[i])],
          paintTool
        );
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = this.getPaint();

    var rect = Offset.zero & size;
    canvas.clipRect(rect);

    var pf = servAnimation.getPreviousFrame();

    if (this.onion && !servAnimation.playing && pf != null) {
      this.drawOffsets(canvas, pf.offsets, paint);
    }

    paint.color = Colors.black;
    var offsets = this.frame != null ? this.frame.offsets : [];
    this.drawOffsets(canvas, offsets, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

}
