import 'package:flutter/material.dart';

import '../services/animation_service.dart';
import '../screens/animation_page.dart';

class NewAnimation extends StatefulWidget {

  @override
  _NewAnimationState createState() => _NewAnimationState();

}

class _NewAnimationState extends State<NewAnimation> {

  TextEditingController nameCtrl;

  void save() async {
    var newAnimation = await servAnimation.createAnimation(this.nameCtrl.text);

    servAnimation.selectAnimation(newAnimation);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => AnimationPage()
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.nameCtrl = TextEditingController();

    return AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      content: Column(
        children: <Widget>[
          TextField(
            controller: this.nameCtrl,
            autofocus: true,
            decoration: new InputDecoration(
              labelText: "Titre de l'animation",
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: const Text('Valider'),
          onPressed: () {
            this.save();

            Navigator.pop(context);
          }
        ),
      ],
    );
  }

}
