import 'package:flutter/material.dart';
import 'dart:ui';

import '../services/animation_service.dart';
import '../screens/animation_page.dart';
import '../screens/list_page.dart';

class MainDrawer extends StatefulWidget {

  MainDrawer() : super();

  @override
  _MainDrawerState createState() => _MainDrawerState();

}

class _MainDrawerState extends State<MainDrawer> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0.0,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10.0),
                  child: Text(servAnimation.currentAnimation.name, style: TextStyle(color: Colors.white)),
                ),
                Text("${servAnimation.currentAnimation.fps} images / secondes", style: TextStyle(color: Colors.white, fontSize: 12.0)),
                Text("${servAnimation.currentAnimation.frames.length} images", style: TextStyle(color: Colors.white, fontSize: 12.0)),
              ]
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            title: Text('Création'),
            onTap: () {
              Navigator.pop(context);

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => AnimationPage()
                ),
              );
            },
          ),
          ListTile(
            title: Text('Mes animations'),
            onTap: () {
              Navigator.pop(context);

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => ListPage()
                ),
              );
            },
          ),
        ],
      ),
    );
  }

}
