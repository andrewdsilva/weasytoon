import 'package:flutter/material.dart';
import 'dart:ui';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'WeasyToon'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

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
            painter: FlipBookPainter(this._offsets),
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

class FlipBookPainter extends CustomPainter {

  final offsets;

  FlipBookPainter(this.offsets): super();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
    ..color = Colors.black
    ..isAntiAlias = true
    ..strokeWidth = 3.0;

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