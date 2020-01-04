import 'package:flutter/material.dart';

import '../services/animation_service.dart';

import 'dot.dart';

class Frame {

  List<Dot> offsets = [];

  Map<String, dynamic> toMap() {
    return {
      'offsets': offsets.map((i) {
        if (i == null) {
          return null;
        } else {
          return {
            'x': i.dx,
            'y': i.dy,
            'type': i.type.toString(),
          };
        }
      }).toList(),
    };
  }

  void initWithValues(Map<String, dynamic> data) {
    this.offsets = data['offsets'].map((i) {
      if (i == null) return null;

      Tool type = Tool.values.firstWhere((e) => e.toString() == i['type']);

      return Dot(i['x'], i['y'], type);
    }).toList().cast<Dot>();
  }

}
