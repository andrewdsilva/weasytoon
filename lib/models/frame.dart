import 'package:flutter/material.dart';

class Frame {

  List<Offset> offsets = [];

  Map<String, dynamic> toMap() {
    return {
      'offsets': offsets.map((i) {
        if (i == null) {
          return null;
        } else {
          return {
            'x': i.dx,
            'y': i.dy,
          };
        }
      }).toList(),
    };
  }

  void initWithValues(Map<String, dynamic> data) {
    this.offsets = data['offsets'].map((i) {
      return i == null ? null : Offset(i['x'], i['y']);
    }).toList().cast<Offset>();
  }

}
