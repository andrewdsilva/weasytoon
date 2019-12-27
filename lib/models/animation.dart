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

  void save() {
    servDatabase.insert(this.table, this);
  }

}
