import 'package:flutter/material.dart';
import 'dart:ui';

void main() => runApp(Weasytoon());

class Weasytoon extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final blue   = Color(0xFF22b3EE);
    final greyBg = Color(0xFFF3F5F7);

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

    return MaterialApp(
      title: 'WeasyToon',
      theme: ThemeData(
        primaryColor: blue,
        primarySwatch: mainBlue,
        scaffoldBackgroundColor: greyBg,
      ),
      home: AnimationsPage(title: 'WeasyToon'),
    );
  }

}

class AnimationsPage extends StatefulWidget {

  AnimationsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AnimationsPageState createState() => _AnimationsPageState();

}

class _AnimationsPageState extends State<AnimationsPage> {

  final _offsets = <Offset>[];

  void addPoint(context, details) {
    final renderObject = context.findRenderObject() as RenderBox;
    final position     = renderObject.globalToLocal(details.globalPosition);

    _offsets.add(position);
  }

  void addNullPoint() {
    _offsets.add(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onPanDown: (details) {
          setState(() {
            this.addPoint(context, details);
          });
        },
        onPanUpdate: (details) {
          setState(() {
            this.addPoint(context, details);
          });
        },
        onPanEnd: (details) {
          setState(() {
            this.addNullPoint();
          });
        },
        child: Center(
          child: CustomPaint(
            painter: AnimationsPainter(this._offsets),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ),
      ),
    );
  }

}

class AnimationsPainter extends CustomPainter {

  final offsets;

  AnimationsPainter(this.offsets): super();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
    ..color = Colors.black
    ..isAntiAlias = true
    ..strokeWidth = 3.0
    ..strokeCap = StrokeCap.round;

    for (var i = 0; i < offsets.length - 1; i++) {
      if (offsets[i] != null && offsets[i + 1] != null) {
        canvas.drawLine(
          offsets[i],
          offsets[i + 1],
          paint
        );
      } else if (offsets[i] != null && offsets[i + 1] == null) {
        canvas.drawPoints(
          PointMode.points,
          [offsets[i]],
          paint
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

}