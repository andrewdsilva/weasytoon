import 'frame.dart';
import 'dart:convert';

import '../services/database_service.dart';

class Animation {

  final String table = "animations";
  int id;

  String name        = "";
  List<Frame> frames = [];
  int fps            = 16;

  Animation(String name) {
    this.name = name;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'data': jsonEncode({
        'id': id,
        'name': name,
        'fps': fps,
        'frames': frames.map((i) {
          return i.toMap();
        }).toList(),
      }),
    };
  }

  void initWithValues(Map<String, dynamic> values) {
    this.id     = values['id'];
    this.name   = values['name'];
    this.fps    = values['fps'];
    this.frames = values['frames'].map((i) {
      var f = Frame();
      f.initWithValues(i);

      return f;
    }).toList().cast<Frame>();
  }

  void save() async {
    await servDatabase.insert(this.table, this);
  }

  void delete() async {
    await servDatabase.delete(this.table, this);
  }

  void deleteFrame(frame) {
    this.frames.removeWhere((f) => f == frame);
  }

}
