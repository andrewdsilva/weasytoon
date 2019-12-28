import 'package:flutter/material.dart';

import '../services/animation_service.dart';

class AnimationSettings extends StatefulWidget {

  @override
  _AnimationSettingsState createState() => _AnimationSettingsState();

}

class _AnimationSettingsState extends State<AnimationSettings> {

  TextEditingController nameCtrl;
  TextEditingController fpsCtrl;

  void save() {
    servAnimation.currentAnimation.name = this.nameCtrl.text;
    servAnimation.currentAnimation.fps  = int.parse(this.fpsCtrl.text);

    servAnimation.currentAnimation.save;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.nameCtrl      = TextEditingController();
    this.nameCtrl.text = servAnimation.currentAnimation.name;

    this.fpsCtrl      = TextEditingController();
    this.fpsCtrl.text = servAnimation.currentAnimation.fps.toString();

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
          TextField(
            controller: this.fpsCtrl,
            decoration: new InputDecoration(
              labelText: "Images par seconde",
            ),
            keyboardType: TextInputType.number,
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
