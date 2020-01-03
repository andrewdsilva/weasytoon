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

enum AnimationFrameMenuItem { delete, copy }

class _AnimationFramesState extends State<AnimationFrames> {

  StreamSubscription<int> stateSubscription;

  ScrollController _scrollController;

  var _tapPosition;

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

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

  void scrollToCurrent() {
    this._scrollController.animateTo(
      this._scrollController.offset + getItemWidth() * servAnimation.getCurrentFrameIndex(),
      curve: Curves.linear,
      duration: Duration (milliseconds: 500)
    );
  }

  void showFrameMenu(menuContext, frame) async {
    final RenderBox overlay = Overlay.of(menuContext).context.findRenderObject();

    final result = await showMenu(
        context: menuContext,
        items: [
          PopupMenuItem(
            child: Text("Supprimer l'image"),
            value: AnimationFrameMenuItem.delete,
          ),
          PopupMenuItem(
            child: Text("Copier l'image"),
            value: AnimationFrameMenuItem.copy,
          ),
        ],
        position: RelativeRect.fromRect(_tapPosition & Size(40, 40), Offset.zero & overlay.size),
    );

    if (result == AnimationFrameMenuItem.delete) {
      servAnimation.deleteFrame(frame);
    } else if (result == AnimationFrameMenuItem.copy) {
      servAnimation.copyFrame(frame);

      this.scrollToCurrent();
    }
  }

  @override
  void initState() {
    stateSubscription = servAnimation.stateObservable.listen(_onChange);
    _scrollController = ScrollController();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    stateSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var frames = servAnimation.currentAnimation != null ? servAnimation.currentAnimation.frames : [];

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
                    onLongPress: () {
                      this.showFrameMenu(context, frame);
                    },
                    onTapDown: _storePosition,
                    onTap: () {
                      servAnimation.selectFrame(frame);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(),
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
              shape: RoundedRectangleBorder(),
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
