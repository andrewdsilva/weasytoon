import 'package:flutter/material.dart' hide Animation;
import 'package:image/image.dart' as ImageLib;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:ui';
import 'dart:io';
import 'dart:typed_data';

import '../components/animation_paint.dart';
import '../components/animation_painter.dart';
import '../components/animation_frames.dart';
import '../components/new_animation.dart';
import '../components/main_drawer.dart';
import '../components/main_appbar.dart';

import '../models/animation.dart';
import '../models/frame.dart';
import '../models/dot.dart';

import '../services/animation_service.dart';

import 'animation_page.dart';

import 'dart:async';

class ListPage extends StatefulWidget {

  ListPage() : super();

  @override
  _ListPageState createState() => _ListPageState();

}

enum ListPageMenuItem { delete, save }

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

  Future<ImageLib.Image> getImage(Frame frame, size) async {
    final PictureRecorder recorder = PictureRecorder();

    AnimationPainter myPainter = AnimationPainter(frame, 1, false, Colors.white);
    myPainter.paint(Canvas(recorder), size);

    final Picture picture = recorder.endRecording();

    var dartUiImage = await picture.toImage(size.width.round(), size.height.round());
    var byteData = await dartUiImage.toByteData();

    var bytes = byteData.buffer.asInt8List();
    var image = await ImageLib.Image.fromBytes(size.width.round(), size.height.round(), bytes);

    return image;
  }

  void saveAnimation(Animation animation, BuildContext theContext) async {
    final PermissionHandler _permissionHandler = PermissionHandler();
    var result = await _permissionHandler.requestPermissions([PermissionGroup.storage]);

    if (result[PermissionGroup.storage] == PermissionStatus.granted) {
      var imageAnimation = ImageLib.Animation();

      var width  = (MediaQuery.of(context).size.width).round();
      var height = (MediaQuery.of(context).size.height * 0.75).round();

      var delay = (100 / animation.fps).round();

      final encoder = ImageLib.GifEncoder();
      encoder.repeat = 0;

      encoder.delay = delay;

      for (var i = 0; i < animation.frames.length; i++) {
        Frame frame = animation.frames[i];

        var image = await getImage(frame, Size(width / 1, height / 1));

        encoder.addFrame(image, duration: delay);
      }

      final gif = encoder.finish();

      var fileName = DateTime.now().millisecondsSinceEpoch.toString();

      final Directory path = await getApplicationDocumentsDirectory();
      final List<Directory> pictures = await getExternalStorageDirectories(type: StorageDirectory.pictures);

      var newPath = pictures[0].path + '/' + fileName + '.gif';

      print("Gif file saved in : " + newPath);

      final File file = File(newPath);
      final File newImage = await file.writeAsBytes(Uint8List.fromList(gif), mode: FileMode.write, flush: true);

      Scaffold.of(theContext).showSnackBar(SnackBar(
        content: Text("Animation exportée dans la galerie du téléphone."),
      ));
    }
  }

  void onAction(ListPageMenuItem action, Animation animation, BuildContext theContext) {
    if (action == ListPageMenuItem.delete) {
      this.deleteAnimation(animation);
    } else if (action == ListPageMenuItem.save) {
      this.saveAnimation(animation, theContext);
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

        body: Builder(
        builder: (theContext) => Container(
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
                            onSelected: (ListPageMenuItem result) { setState(() { onAction(result, animation, theContext); }); },
                            itemBuilder: (BuildContext context) => <PopupMenuEntry<ListPageMenuItem>>[
                              const PopupMenuItem<ListPageMenuItem>(
                                value: ListPageMenuItem.delete,
                                child: Text("Supprimer l'animation"),
                              ),
                              const PopupMenuItem<ListPageMenuItem>(
                                value: ListPageMenuItem.save,
                                child: Text("Exporter en gif"),
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
