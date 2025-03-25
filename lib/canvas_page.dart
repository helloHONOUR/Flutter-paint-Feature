import 'dart:ui';
import 'package:drawingcanvas/models/sketchmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CanvasPage extends StatefulWidget {
  final AnimationController animationcontroller;
  final ValueNotifier<Sketch> currentstroke;
  final ValueNotifier<List<Sketch>> allstroke;
  final ValueNotifier<double> strokesize;
  final ValueNotifier<double> erasersize;
  final ValueNotifier<Color> colorselected;
  final ValueNotifier<Sketchtool> toolselected;
  final ValueNotifier<bool> fill;

  const CanvasPage({
    super.key,
    required this.currentstroke,
    required this.allstroke,
    required this.strokesize,
    required this.erasersize,
    required this.colorselected,
    required this.toolselected,
    required this.animationcontroller,
    required this.fill,
  });

  @override
  State<CanvasPage> createState() => _CanvasPageState();
}

class _CanvasPageState extends State<CanvasPage> {
  List<Sketch> listofsketch = [];
  List<Offset> listofEraseroffset = [];
  Widget allsketch() {
    return CustomPaint(
      painter: PaintCanvas(
        listofallsketch: widget.allstroke.value,
      ),
    );
  }

  Widget currentsketch(BuildContext context) {
    return Listener(
      onPointerDown: (details) {
        final renderBox = context.findRenderObject() as RenderBox;
        final offset = renderBox.globalToLocal(details.position);
        widget.currentstroke.value = Sketch(
          points: [offset],
          color: widget.colorselected.value,
          strokesize: widget.strokesize.value,
          fill: widget.fill.value,
          sketchtool: widget.toolselected.value,
        );
      },
      onPointerUp: (details) {
        widget.allstroke.value = List<Sketch>.from(widget.allstroke.value)..add(widget.currentstroke.value);
      },
      onPointerMove: (details) {
        final renderBox = context.findRenderObject() as RenderBox;
        final offset = renderBox.globalToLocal(details.position);

        final points = List<Offset>.from(widget.currentstroke.value.points)..add(offset);
        widget.currentstroke.value = Sketch(
          points: points,
          color: widget.colorselected.value,
          strokesize: widget.strokesize.value,
          fill: widget.fill.value,
          sketchtool: widget.toolselected.value,
        );
      },
      child: CustomPaint(
        painter: PaintCanvas(listofcurrentsketch: [widget.currentstroke.value]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onTap: () {
          widget.animationcontroller.reverse();
        },
        child: Container(
            color: Color(0xfff2f3f7),
            child: Stack(children: [
              Positioned.fill(child: allsketch()),
              Positioned.fill(child: currentsketch(context)),
            ])),
      ),
    );
  }
}

class PaintCanvas extends CustomPainter {
  final List<Sketch>? listofcurrentsketch;
  final List<Sketch>? listofallsketch;

  const PaintCanvas({this.listofallsketch, this.listofcurrentsketch});

  stroke(Canvas canvas, List<Offset> listofpoints, Paint paint) {
    List<Offset> points = listofpoints;

    Path path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 1; i < points.length - 1; i++) {
      final p0 = points[i];

      final p1 = points[i + 1];

      path.quadraticBezierTo(
        p0.dx,
        p0.dy,
        (p0.dx + p1.dx) / 2,
        (p0.dy + p1.dy) / 2,
      );
    }

    canvas.drawPath(path, paint);
  }

  line(Canvas canvas, List<Offset> listofpoints, Paint paint) {
    List<Offset> points = listofpoints;
    canvas.drawLine(points.first, points.last, paint);
  }

  square(Canvas canvas, List<Offset> listofpoints, Paint paint) {
    List<Offset> points = listofpoints;
    Rect rect = Rect.fromPoints(points.first, points.last);
    canvas.drawRect(rect, paint);
  }

  circle(Canvas canvas, List<Offset> listofpoints, Paint paint) {
    List<Offset> points = listofpoints;
    Rect rect = Rect.fromPoints(points.first, points.last);
    canvas.drawOval(rect, paint);
  }

  eraser(Canvas canvas, List<Offset> listofpoints, Paint paint) {
    stroke(canvas, listofpoints, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (listofcurrentsketch != null) {
      for (Sketch sketch in listofcurrentsketch!) {
        Paint paint = Paint()
          ..strokeWidth = sketch.strokesize!
          ..style = sketch.fill == true ? PaintingStyle.fill : PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..color = sketch.sketchtool == Sketchtool.eraser ? Color(0xfff2f3f7) : sketch.color!;
        final points = sketch.points;

        if (points.isEmpty) return;

        switch (sketch.sketchtool) {
          case Sketchtool.pencil:
            stroke(canvas, points, paint);
          case Sketchtool.line:
            line(canvas, points, paint);
          case Sketchtool.square:
            square(canvas, points, paint);
          case Sketchtool.circle:
            circle(canvas, points, paint);
          case Sketchtool.eraser:
            eraser(canvas, points, paint);

            break;
        }
      }
    }

    if (listofallsketch != null) {
      if (listofallsketch!.length > 1) {
        for (Sketch sketch in listofallsketch!) {
          Paint paint = Paint()
            ..strokeWidth = sketch.strokesize!
            ..style = sketch.fill == true ? PaintingStyle.fill : PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..color = sketch.sketchtool == Sketchtool.eraser ? Color(0xfff2f3f7) : sketch.color!;
          if (sketch == listofallsketch!.first) {
            continue;
          } else {
            final points = sketch.points;

            switch (sketch.sketchtool) {
              case Sketchtool.pencil:
                stroke(canvas, points, paint);
              case Sketchtool.line:
                line(canvas, points, paint);
              case Sketchtool.square:
                square(canvas, points, paint);
              case Sketchtool.circle:
                circle(canvas, points, paint);
              case Sketchtool.eraser:
                eraser(canvas, points, paint);

                break;
            }
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant PaintCanvas oldDelegate) {
    if (oldDelegate.listofallsketch != listofallsketch) {
      return true;
    }
    if (oldDelegate.listofcurrentsketch != listofcurrentsketch) {
      return true;
    }
    return false;
  }
}
