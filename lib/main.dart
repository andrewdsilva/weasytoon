import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:ui';

import 'screens/animation_page.dart';

void main() => runApp(Weasytoon());

class Weasytoon extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final blue      = Color(0xFF22b3EE);
    final blueLight = Color(0xFFCBF0FF);
    final greyBg    = Color(0xFFF3F5F7);
    final textBlack = Color(0xFF5A8A9D);

    final MaterialColor mainBlue = const MaterialColor(
      0xFF22b3EE,
      const <int, Color>{
        50: const Color.fromRGBO(34, 179, 238, .1),
        100: const Color.fromRGBO(34, 179, 238, .2),
        200: const Color.fromRGBO(34, 179, 238, .3),
        300: const Color.fromRGBO(34, 179, 238, .4),
        400: const Color.fromRGBO(34, 179, 238, .5),
        500: const Color.fromRGBO(34, 179, 238, .6),
        600: const Color.fromRGBO(34, 179, 238, .7),
        700: const Color.fromRGBO(34, 179, 238, .8),
        800: const Color.fromRGBO(34, 179, 238, .9),
        900: const Color.fromRGBO(34, 179, 238, 1),
      },
    );

      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);

    return MaterialApp(
      title: 'WeasyToon',
      theme: ThemeData(
        primaryColor: blue,
        primarySwatch: mainBlue,
        primaryColorLight: blueLight,
        primaryTextTheme: TextTheme(
          title: TextStyle(
            color: Colors.white
          ),
        ),
        primaryIconTheme: IconThemeData(color: Colors.white),
        scaffoldBackgroundColor: greyBg,
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'Open Sans',
          bodyColor: textBlack,
          displayColor: textBlack
        ),
      ),
      home: AnimationPage(),
    );
  }

}
