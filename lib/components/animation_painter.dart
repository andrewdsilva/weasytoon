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

  AnimationPainter(Frame frame, double proportion, bool onion) :
    this.frame        = frame,
    this.proportion   = proportion,
    this.onion        = onion,
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

  void drawOffsets(canvas, offsets, paint) {
    for (var i = 0; i < offsets.length - 1; i++) {
      if (offsets[i] != null && offsets[i + 1] != null) {
        canvas.drawLine(
          this.adaptOffset(offsets[i]),
          this.adaptOffset(offsets[i + 1]),
          paint
        );
      } else if (offsets[i] != null && offsets[i + 1] == null) {
        canvas.drawPoints(
          PointMode.points,
          [this.adaptOffset(offsets[i])],
          paint
        );
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
    ..color = Colors.grey
    ..isAntiAlias = true
    ..strokeWidth = this.getStrokeWidth()
    ..strokeCap = StrokeCap.round;

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
