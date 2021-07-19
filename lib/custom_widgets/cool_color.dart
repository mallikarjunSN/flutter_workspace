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

  static final Color primaryColor = Color(0xff00b294);

  final List<int> _colorCodes = [
    0xEC008C,
    0xFC6767,
    0x753A88, //choice 1
    0x77A1D3,
    0x79CBCA,
    0xE684AE, //c2
    0xFF637F, //
    0x16A085,
  ];

  final List<Color> _flutterColors = [
    Colors.amber,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.cyan,
    Colors.blueAccent,
    Colors.cyanAccent,
    Colors.indigo,
    Colors.limeAccent,
    Colors.pink,
    Color(0xFF77A1D3),
    Color(0xFF753A88),
  ];

  List<Color> nRandomColors(int n) {
    List<Color> colors = [];
    for (var i = 0; i < n;) {
      Color color = _flutterColors[Random().nextInt(_flutterColors.length - 1)];
      if (colors.contains(color)) {
        continue;
      } else {
        colors.add(color);
        i++;
      }
    }

    return colors;
  }

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
