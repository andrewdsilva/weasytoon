import 'package:flutter/material.dart';
import 'dart:ui';

import 'animation_paint.dart';
import 'animation_frames.dart';
import 'animation_settings.dart';

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
      iconSize: 20.0,
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

  IconButton makeSettingsButton() {
    return IconButton(
      iconSize: 20.0,
      icon: Icon(Icons.settings),
      color: Colors.white,
      onPressed: _showDialogSettings,
    );
  }

  void _showDialogSettings() async {
    await showDialog<String>(
      context: context,
      child: AnimationSettings()
    );
  }

  void makeActions() {
    this.actions = [
      this.makePlayButton(),
      this.makeSettingsButton(),
    ];
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
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                'assets/images/weasytoon.png',
                fit: BoxFit.cover,
                height: 20.0,
              ),
            ],
          ),
          actions: this.actions,
          elevation: 0.0,
        ),
      ),
      body: Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,

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
