import 'package:flutter/material.dart';
import 'dart:ui';

import '../components/animation_paint.dart';
import '../components/animation_frames.dart';
import '../components/animation_settings.dart';
import '../components/main_drawer.dart';
import '../components/main_appbar.dart';

import '../services/animation_service.dart';

import 'dart:async';

class AnimationPage extends StatefulWidget {

  AnimationPage() : super();

  @override
  _AnimationPageState createState() => _AnimationPageState();

}

class _AnimationPageState extends State<AnimationPage> {

  StreamSubscription<int> stateSubscription;

  double iconSize = 20.0;

  Widget makePlayButton() {
    return IconButton(
      iconSize: this.iconSize,
      icon: Icon(servAnimation.playing ? Icons.stop : Icons.play_arrow),
      color: Colors.white,
      onPressed: () {
        setState(() {
          servAnimation.playing = !servAnimation.playing;

          if (servAnimation.playing) {
            servAnimation.play();
          } else {
            servAnimation.stop();
          }
        });
      },
    );
  }

  Widget makeSettingsButton() {
    return IconButton(
      iconSize: this.iconSize,
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

  List<Widget> makeActions() {
    return [
      this.makePlayButton(),
      this.makeSettingsButton(),
    ];
  }

  void _onChange(int state) {
    setState(() {});
  }

  @override
  void initState() {
    stateSubscription = servAnimation.stateObservable.listen(_onChange);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    stateSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,

      drawerEdgeDragWidth: 0.0,

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child: MainAppBar(this.makeActions),
      ),

      endDrawer: MainDrawer(),

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
