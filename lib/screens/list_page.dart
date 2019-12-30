import 'package:flutter/material.dart' hide Animation;
import 'dart:ui';

import '../components/animation_paint.dart';
import '../components/animation_frames.dart';
import '../components/new_animation.dart';
import '../components/main_drawer.dart';
import '../components/main_appbar.dart';

import '../models/animation.dart';

import '../services/animation_service.dart';

import 'animation_page.dart';

import 'dart:async';

class ListPage extends StatefulWidget {

  ListPage() : super();

  @override
  _ListPageState createState() => _ListPageState();

}

class _ListPageState extends State<ListPage> {

  ShapeBorder getAnimationBorder(Animation animation) {
    if (animation == servAnimation.currentAnimation) {
      return RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
        side: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 2.0,
        ),
      );
    } else {
      return RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      );
    }

      return RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      );
  }

  Color getAnimationBackground(Animation animation) {
    // if (animation == servAnimation.currentAnimation) {
    //   return Theme.of(context).primaryColorLight;
    // } else {
    //   return Colors.white;
    // }

    return Colors.white;
  }

  void newAnimationDialog() {
    showDialog<String>(
      context: context,
      child: NewAnimation()
    );
  }

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

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) => AnimationPage()
                    ),
                  );
                },
                child: Card(
                  color: this.getAnimationBackground(animation),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 5.0),
                          child: Text(animation.name, style: TextStyle(color: Theme.of(context).primaryColor)),
                        ),
                        Text("${animation.frames.length} images", style: TextStyle(color: Colors.grey, fontSize: 12.0)),
                      ],
                    ),
                  ),
                  shape: this.getAnimationBorder(animation),
                ),
              );
            }).toList().cast<Widget>(),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          this.newAnimationDialog();
        },
        child: IconTheme(
          data: IconThemeData(color: Colors.white), 
          child: Icon(Icons.add),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

}
