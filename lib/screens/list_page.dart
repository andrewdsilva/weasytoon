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

enum ListPageMenuItem { delete }

class _ListPageState extends State<ListPage> {

  StreamSubscription<int> stateSubscription;

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

  void deleteAnimation(Animation animation) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Annuler"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Supprimer"),
      onPressed:  () {
        servAnimation.deleteAnimation(animation);

        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Supprimer une animation"),
      content: Text("Voulez-vous vraiment supprimer cette animation?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void onAction(ListPageMenuItem action, Animation animation) {
    if (action == ListPageMenuItem.delete) {
      this.deleteAnimation(animation);
    }
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
                  child: Stack(
                    children: <Widget>[
                      Padding(
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

                      Positioned(
                        top: 0,
                        right: 0,
                        child: PopupMenuButton<ListPageMenuItem>(
                          icon: Icon(Icons.more_vert, color: Colors.grey),
                          onSelected: (ListPageMenuItem result) { setState(() { onAction(result, animation); }); },
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<ListPageMenuItem>>[
                            const PopupMenuItem<ListPageMenuItem>(
                              value: ListPageMenuItem.delete,
                              child: Text("Supprimer l'animation"),
                            ),
                          ],
                        ),
                      ),
                    ],
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
