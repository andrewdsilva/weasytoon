import 'package:flutter/material.dart';
import 'dart:ui';

import '../services/animation_service.dart';

import 'dart:async';

class MainAppBar extends StatefulWidget {

  Function customActions;

  MainAppBar(this.customActions) : super();

  @override
  _MainAppBarState createState() => _MainAppBarState(this.customActions);

}

class _MainAppBarState extends State<MainAppBar> {

  StreamSubscription<int> stateSubscription;

  Function customActions;

  _MainAppBarState(this.customActions) : super();

  Widget makeDrawerButton() {
    return Builder(
      builder: (context) => IconButton(
        iconSize: 30,
        icon: Icon(Icons.menu),
        color: Colors.white,
        onPressed: () {
          Scaffold.of(context).openEndDrawer();
        },
      ),
    );
  }

  List<Widget> makeActions() {
    return this.customActions() + [
      this.makeDrawerButton(),
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
    return AppBar(
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
      actions: this.makeActions(),
      elevation: 0.0,
    );
  }

}
