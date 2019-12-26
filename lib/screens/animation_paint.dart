import 'package:flutter/material.dart';
import 'dart:ui';

import 'animation_painter.dart';
import '../services/animation_service.dart';

class AnimationPaint extends StatefulWidget {

  AnimationPaint() : super();

  @override
  _AnimationPaintState createState() => _AnimationPaintState();

}

class _AnimationPaintState extends State<AnimationPaint> {

  void addPoint(context, details) {
    final renderObject = context.findRenderObject() as RenderBox;
    final position     = renderObject.globalToLocal(details.globalPosition);

    servAnimation.currentFrame.offsets.add(position);
  }

  void addNullPoint() {
    servAnimation.currentFrame.offsets.add(null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: GestureDetector(
        onPanDown: (details) {
          setState(() {
            this.addPoint(context, details);
          });
        },
        onPanUpdate: (details) {
          setState(() {
            this.addPoint(context, details);
          });
        },
        onPanEnd: (details) {
          setState(() {
            this.addNullPoint();
          });
        },
        child: Center(
          child: CustomPaint(
            painter: AnimationPainter(servAnimation.currentFrame, 1),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ),
      ),
    );
  }

}
