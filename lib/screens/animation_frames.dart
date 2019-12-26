import 'package:flutter/material.dart';
import 'dart:ui';

import 'animation_painter.dart';
import '../services/animation_service.dart';
import '../models/frame.dart';

import 'dart:async';

class AnimationFrames extends StatefulWidget {

  AnimationFrames() : super();

  @override
  _AnimationFramesState createState() => _AnimationFramesState();

}

class _AnimationFramesState extends State<AnimationFrames> {

  StreamSubscription<int> stateSubscription;

  ScrollController _scrollController;

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

  void _onChange(int state) {
    this.setState(() {});
  }

  void scrollToTheEnd() {
    this._scrollController.animateTo(
      this._scrollController.offset + getItemWidth() * servAnimation.currentAnimation.frames.length,
      curve: Curves.linear,
      duration: Duration (milliseconds: 500)
    );
  }

  @override
  void initState() {
    stateSubscription = servAnimation.stateObservable.listen(_onChange);
    _scrollController = ScrollController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var frames = servAnimation.currentAnimation.frames;

    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
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
                        painter: AnimationPainter(frame, this.getProportion(), false),
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

              this.scrollToTheEnd();
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
