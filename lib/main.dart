import 'package:drawingcanvas/canvas_page.dart';
import 'package:drawingcanvas/canvas_sidebar.dart';
import 'package:drawingcanvas/models/sketchmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart' show SvgPicture;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 0.1),
              bodySmall:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 10, letterSpacing: 0.1))),
      home: const DrawingCanvas(),
    );
  }
}

class DrawingCanvas extends StatefulWidget {
  const DrawingCanvas({super.key});

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> with SingleTickerProviderStateMixin {
  late AnimationController animationcontroller;
  ValueNotifier<double> strokesize = ValueNotifier(5);
  ValueNotifier<double> erasersize = ValueNotifier(4);
  ValueNotifier<Color> colorselected = ValueNotifier(Colors.black);
  ValueNotifier<Sketchtool> toolselected = ValueNotifier(Sketchtool.pencil);
  ValueNotifier<Sketch> currentstroke = ValueNotifier(Sketch(points: []));
  ValueNotifier<List<Sketch>> allstroke = ValueNotifier([Sketch(points: [])]);
  ValueNotifier<bool> fill = ValueNotifier(false);
  @override
  void initState() {
    animationcontroller = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f3f7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Drawing Canvas',
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.w500, decoration: TextDecoration.none),
        ),
        leading: SafeArea(
            child: Row(children: [
          IconButton(
              onPressed: () {
                if (animationcontroller.status == AnimationStatus.completed) {
                  animationcontroller.reverse();
                } else {
                  animationcontroller.forward();
                  print('opening');
                }
              },
              icon: const Icon(Icons.menu, color: Colors.black)),
        ])),
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: Stack(children: [
            AnimatedBuilder(
              animation: Listenable.merge([
                currentstroke,
                allstroke,
                erasersize,
                colorselected,
                toolselected,
                currentstroke,
              ]),
              builder: (BuildContext context, _) {
                return CanvasPage(
                  currentstroke: currentstroke,
                  allstroke: allstroke,
                  strokesize: strokesize,
                  colorselected: colorselected,
                  erasersize: erasersize,
                  toolselected: toolselected,
                  animationcontroller: animationcontroller,
                  fill: fill,
                );
              },
            ),
            CanvasSidebar(
              animationcontroller: animationcontroller,
              strokesize: strokesize,
              erasersize: erasersize,
              colorselected: colorselected,
              toolselected: toolselected,
              fill: fill,
            ),
          ]),
        ),
      ),
    );
  }
}
