import 'package:flutter/material.dart';

import '../services/animation_service.dart';

class Dot extends Offset {

  Tool type;

  Dot(double dx, double dy, this.type) : super(dx, dy);

}