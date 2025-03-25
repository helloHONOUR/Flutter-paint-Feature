import 'dart:ffi';

import 'package:flutter/material.dart';

class Sketch {
  List<Offset> points = [];
  Color? color;
  double? strokesize;
  Sketchtool sketchtool;
  bool fill;

  Sketch({
    required this.points,
    this.color = Colors.black,
    this.strokesize = 5,
    this.sketchtool = Sketchtool.pencil,
    this.fill = false,
  });
}

enum Sketchtool { pencil, line, eraser, square, circle }
