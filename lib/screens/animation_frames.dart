import 'package:flutter/material.dart';
import 'dart:ui';

import 'animation_painter.dart';
import '../services/animation_service.dart';
import '../models/frame.dart';

class AnimationFrames extends StatefulWidget {

  AnimationFrames() : super();

  @override
  _AnimationFramesState createState() => _AnimationFramesState();

}

class _AnimationFramesState extends State<AnimationFrames> {

  double getProportion() {
    var frameHeight = MediaQuery.of(context).size.height * 0.75;
    var itemHeight  = MediaQuery.of(context).size.height * 0.1;

    return itemHeight / frameHeight;
  }

  double getItemWidth() {
    var frameWidth  = MediaQuery.of(context).size.width;

    return frameWidth * this.getProportion();
  }

  Color getFrameBackground(Frame frame) {
    if (frame == servAnimation.currentFrame) {
      return Theme.of(context).primaryColorLight;
    } else {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    var frames = servAnimation.currentAnimation.frames;

    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: frames.length,
              itemBuilder: (BuildContext context, int index) {
                var frame = frames[index];

                return SizedBox(
                  width: getItemWidth(),
                  child: InkWell(
                    onTap: () {
                      servAnimation.selectFrame(frame);
                    },
                    child: Card(
                      child: CustomPaint(
                        painter: AnimationPainter(frame, this.getProportion()),
                      ),
                      color: this.getFrameBackground(frame),
                    ),
                  ),
                );
              },
            ),
          ),
          InkWell(
            onTap: () {
              servAnimation.newFrame();
            },
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: Text('+', style: TextStyle(color: Colors.white))),
              ),
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

}
