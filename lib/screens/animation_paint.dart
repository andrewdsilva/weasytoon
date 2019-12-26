import 'package:flutter/material.dart';
import 'dart:ui';

import 'animation_painter.dart';

class AnimationPaint extends StatefulWidget {

  AnimationPaint() : super();

  @override
  _AnimationPaintState createState() => _AnimationPaintState();

}

class _AnimationPaintState extends State<AnimationPaint> {
  final _offsets = <Offset>[];

  void addPoint(context, details) {
    final renderObject = context.findRenderObject() as RenderBox;
    final position     = renderObject.globalToLocal(details.globalPosition);

    _offsets.add(position);
  }

  void addNullPoint() {
    _offsets.add(null);
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
            painter: AnimationPainter(this._offsets),
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
