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

}
