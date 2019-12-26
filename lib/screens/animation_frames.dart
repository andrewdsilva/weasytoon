import 'package:flutter/material.dart';
import 'dart:ui';

import 'animation_painter.dart';

class AnimationFrames extends StatefulWidget {

  AnimationFrames() : super();

  @override
  _AnimationFramesState createState() => _AnimationFramesState();

}

class _AnimationFramesState extends State<AnimationFrames> {

  double getItemWidth() {
    var frameWidth  = MediaQuery.of(context).size.width;
    var frameHeight = MediaQuery.of(context).size.height * 0.75;
    var itemHeight  = MediaQuery.of(context).size.height * 0.1;

    var itemWidth = frameWidth * itemHeight / frameHeight;

    return itemWidth;
  }

  Color getFrameBackground(int index) {
    if (index == 0) {
      return Theme.of(context).primaryColorLight;
    } else {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    var items = [1, 2, 3, 4];

    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                final item = items[index];

                return SizedBox(
                  width: getItemWidth(),
                  child: Card(
                    child: CustomPaint(
                      painter: AnimationPainter([Offset(0,0), Offset(15,20)]),
                    ),
                    color: this.getFrameBackground(index),
                  ),
                );
              },
            ),
          ),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: Text('+', style: TextStyle(color: Colors.white))),
            ),
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }

}
