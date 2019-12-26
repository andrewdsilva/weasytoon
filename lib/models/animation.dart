import 'frame.dart';

class Animation {

  String name        = "";
  List<Frame> frames = [];
  int fps            = 16;

  Animation(String name) {
    this.name = name;
  }

}
