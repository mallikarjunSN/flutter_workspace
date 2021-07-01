import 'dart:math';

import 'package:flutter/material.dart';

class CoolColor {
  CoolColor() {
    for (var code in _colorCodes) {
      _colors.add(getColor(code));
    }
  }

  Color getColor(int val) {
    int r = val >> 16 & 0xff;
    int g = val >> 8 & 0xff;
    int b = val & 0xff;

    return Color.fromRGBO(r, g, b, 1);
  }

  List<Color> _colors = [];
  int val;

  final List<int> _colorCodes = [
    0xEC008C,
    0xFC6767,
    0x753A88, //choice 1
    0x77A1D3,
    0x79CBCA,
    0xE684AE, //c2
    0xFF637F, //
    0x16A085
  ];

  List<Color> getRandomColors(int n) {
    List<Color> colors = [];

    for (var i = 0; i < n;) {
      Color color = _colors[Random().nextInt(_colors.length - 1)];
      if (colors.contains(color)) {
        continue;
      } else {
        colors.add(color);
        i++;
      }
    }

    return colors;
  }
}
