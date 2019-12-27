import 'package:flutter/material.dart';
import 'dart:ui';

import 'animation_paint.dart';
import 'animation_frames.dart';

import '../services/animation_service.dart';

import 'dart:async';

class AnimationPage extends StatefulWidget {

  AnimationPage() : super();

  @override
  _AnimationPageState createState() => _AnimationPageState();

}

class _AnimationPageState extends State<AnimationPage> {

  StreamSubscription<int> stateSubscription;

  List<Widget> actions = [];

  IconButton makePlayButton() {
    return IconButton(
      icon: Icon(servAnimation.playing ? Icons.stop : Icons.play_arrow),
      color: Colors.white,
      onPressed: () {
        setState(() {
          servAnimation.playing = !servAnimation.playing;
          this.makeActions();

          if (servAnimation.playing) {
            servAnimation.play();
          } else {
            servAnimation.stop();
          }
        });
      },
    );
  }

  void makeActions() {
    this.actions = [this.makePlayButton()];
  }

  void _onChange(int state) {
    setState(() {
      this.makeActions();
    });
  }

  @override
  void initState() {
    stateSubscription = servAnimation.stateObservable.listen(_onChange);

    this.makeActions();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation'),
        actions: this.actions,
        elevation: 0.0,
      ),
      body: Scaffold(
        body: Container(
          decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
          child: Column(
            children: <Widget>[
              AnimationPaint(),
              Expanded(
                child: AnimationFrames(),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
