import 'dart:math';

import 'package:flutter/material.dart';

class SineCurve extends Curve {
  SineCurve({this.count = 100});

  final int count;

  @override
  double transformInternal(double t) {
    var val = sin(count * 2 * pi * t) * 0.5 + 0.5;

    return val;
  }
}
