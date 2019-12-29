import 'package:flutter/material.dart';
import 'dart:ui';

import '../components/animation_paint.dart';
import '../components/animation_frames.dart';
import '../components/animation_settings.dart';
import '../components/main_drawer.dart';
import '../components/main_appbar.dart';

import '../services/animation_service.dart';

import 'dart:async';

class ListPage extends StatefulWidget {

  ListPage() : super();

  @override
  _ListPageState createState() => _ListPageState();

}

class _ListPageState extends State<ListPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,

      drawerEdgeDragWidth: 0.0,

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child: MainAppBar(() { return [].toList().cast<Widget>(); }),
      ),

      endDrawer: MainDrawer(),

      body: Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,

        body: Container(
          decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
          child: ListView(
            children: servAnimation.animations.map((animation) {
              return InkWell(
                onTap: () {
                  servAnimation.selectAnimation(animation);
                },
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                    child: Text(animation.name, style: TextStyle(color: Theme.of(context).primaryColor)),
                  ),
                ),
              );
            }).toList().cast<Widget>(),
          ),
        ),
      ),
    );
  }

}
