import 'package:flutter/material.dart';
import 'dart:ui';

import 'animation_painter.dart';
import '../services/animation_service.dart';

import 'dart:async';

class AnimationPaint extends StatefulWidget {

  AnimationPaint() : super();

  @override
  _AnimationPaintState createState() => _AnimationPaintState();

}

class _AnimationPaintState extends State<AnimationPaint> {

  StreamSubscription<int> stateSubscription;

  void addPoint(context, details) {
    final renderObject = context.findRenderObject() as RenderBox;
    final position     = renderObject.globalToLocal(details.globalPosition);

    servAnimation.currentFrame.offsets.add(position);
  }

  void addNullPoint() {
    servAnimation.currentFrame.offsets.add(null);
  }

  void _onChange(int state) {
    this.setState(() {});
  }

  double getHeight() {
    return MediaQuery.of(context).size.height * 0.75;
  }

  @override
  void initState() {
    stateSubscription = servAnimation.stateObservable.listen(_onChange);
    super.initState();
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
            painter: AnimationPainter(servAnimation.currentFrame, 1, true),
            child: Container(
              height: this.getHeight(),
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ),
      ),
    );
  }

}
