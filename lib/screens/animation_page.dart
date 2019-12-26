import 'package:flutter/material.dart';
import 'dart:ui';

import 'animation_paint.dart';
import 'animation_frames.dart';

import '../services/animation_service.dart';

class AnimationPage extends StatelessWidget {

  AnimationPage() : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }

}
