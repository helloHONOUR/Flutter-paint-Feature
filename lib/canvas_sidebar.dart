import 'dart:ffi';

import 'package:drawingcanvas/models/sketchmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CanvasSidebar extends StatelessWidget {
  final AnimationController animationcontroller;
  final ValueNotifier<double> strokesize;
  final ValueNotifier<double> erasersize;
  final ValueNotifier<Color> colorselected;
  final ValueNotifier<Sketchtool> toolselected;
  final ValueNotifier<bool> fill;
  const CanvasSidebar({
    required this.animationcontroller,
    required this.strokesize,
    required this.erasersize,
    required this.colorselected,
    required this.toolselected,
    super.key,
    required this.fill,
  });

  Future colorPalete(context, ValueNotifier<Color> colorselected) {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: SingleChildScrollView(
              child: AlertDialog(
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Done',
                        textAlign: TextAlign.end,
                      ))
                ],
                title: const Text(
                  'Pick a Color',
                  style: TextStyle(fontSize: 18),
                ),
                content: ColorPicker(
                  pickerColor: colorselected.value,
                  onColorChanged: (Color value) {
                    print(value.hashCode);
                    colorselected.value = value;
                  },
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Color colortoolselected = Colors.black;
    Color colortoolunselected = Colors.grey;
    List<Color> colors = [
      Colors.black,
      Colors.white,
      ...Colors.primaries,
    ];

    return AnimatedBuilder(
        animation: Listenable.merge([
          strokesize,
          erasersize,
          colorselected,
          toolselected,
          fill,
        ]),
        builder: (BuildContext context, _) {
          return Positioned(
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-10, 0),
                end: Offset.zero,
              ).animate(animationcontroller),
              child: Container(
                color: Colors.white,
                alignment: AlignmentDirectional.topStart,
                padding: const EdgeInsets.all(10),
                width: MediaQuery.sizeOf(context).width / 1.5,
                height: MediaQuery.sizeOf(context).height / 2,
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(bottom: 3),
                      margin: const EdgeInsets.only(bottom: 7),
                      decoration: const BoxDecoration(
                          border: BorderDirectional(
                              bottom: BorderSide(color: Color.fromARGB(255, 225, 220, 220), width: 2))),
                      child: Text(
                        'Shapes',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              toolselected.value = Sketchtool.pencil;
                            },
                            child: Container(
                                margin: const EdgeInsets.only(right: 6),
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: toolselected.value == Sketchtool.pencil
                                            ? colortoolselected
                                            : colortoolunselected,
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Icon(
                                  Icons.edit,
                                  color:
                                      toolselected.value == Sketchtool.pencil ? colortoolselected : colortoolunselected,
                                ))),
                        GestureDetector(
                            onTap: () {
                              toolselected.value = Sketchtool.line;
                            },
                            child: Container(
                                margin: const EdgeInsets.only(right: 6),
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: toolselected.value == Sketchtool.line
                                            ? colortoolselected
                                            : colortoolunselected,
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Icon(
                                  Icons.horizontal_rule,
                                  color:
                                      toolselected.value == Sketchtool.line ? colortoolselected : colortoolunselected,
                                ))),
                        GestureDetector(
                            onTap: () {
                              toolselected.value = Sketchtool.eraser;
                            },
                            child: Container(
                                margin: const EdgeInsets.only(right: 6),
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: toolselected.value == Sketchtool.eraser
                                            ? colortoolselected
                                            : colortoolunselected,
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Icon(
                                  MdiIcons.eraserVariant, // Eraser icon
                                  color:
                                      toolselected.value == Sketchtool.eraser ? colortoolselected : colortoolunselected,
                                ))),
                        GestureDetector(
                            onTap: () {
                              toolselected.value = Sketchtool.square;
                            },
                            child: Container(
                                margin: const EdgeInsets.only(right: 6),
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: toolselected.value == Sketchtool.square
                                            ? colortoolselected
                                            : colortoolunselected,
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Icon(
                                  MdiIcons.squareOutline, // Eraser icon
                                  color:
                                      toolselected.value == Sketchtool.square ? colortoolselected : colortoolunselected,
                                ))),
                        GestureDetector(
                            onTap: () {
                              toolselected.value = Sketchtool.circle;
                            },
                            child: Container(
                                margin: const EdgeInsets.only(right: 6),
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: toolselected.value == Sketchtool.circle
                                            ? colortoolselected
                                            : colortoolunselected,
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Icon(
                                  MdiIcons.circleOutline, // Eraser icon
                                  color:
                                      toolselected.value == Sketchtool.circle ? colortoolselected : colortoolunselected,
                                ))),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(
                        top: 15,
                        bottom: 15,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Fill Shape:',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Checkbox(
                              value: fill.value,
                              onChanged: (val) {
                                print(val);
                                fill.value = val ?? false;
                              })
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(bottom: 3),
                      margin: const EdgeInsets.only(bottom: 7),
                      decoration: const BoxDecoration(
                          border: BorderDirectional(
                              bottom: BorderSide(color: Color.fromARGB(255, 225, 220, 220), width: 2))),
                      child: Text(
                        'Colors',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Column(
                      children: [
                        Wrap(
                          children: [
                            for (Color color in colors)
                              GestureDetector(
                                onTap: () {
                                  colorselected.value = color;
                                  print('done');
                                },
                                child: Container(
                                  height: 25,
                                  width: 25,
                                  margin: const EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                      color: color,
                                      border: Border.all(
                                        color: color == colorselected.value ? colortoolselected : colortoolunselected,
                                      ),
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                              )
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 25,
                                width: 25,
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: colorselected.value,
                                    border: Border.all(color: colortoolunselected, width: 1.5),
                                    borderRadius: BorderRadius.circular(3)),
                              ),
                              GestureDetector(
                                onTap: () {
                                  colorPalete(context, colorselected);
                                },
                                child: SvgPicture.asset(
                                  'assets/Colorwheel1.svg',
                                  width: 25,
                                  height: 25,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(bottom: 3),
                      margin: const EdgeInsets.only(bottom: 7),
                      decoration: const BoxDecoration(
                          border: BorderDirectional(
                              bottom: BorderSide(color: Color.fromARGB(255, 225, 220, 220), width: 2))),
                      child: Text(
                        'Sizes',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Stroke Size:',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Card(
                          color: Colors.white,
                          elevation: 0,
                          child: Slider(
                            thumbColor: Colors.blue,
                            activeColor: Colors.blue,
                            value: strokesize.value,
                            min: 5,
                            max: 15,
                            onChanged: (val) {
                              print(val);
                              strokesize.value = val;
                            },
                            divisions: 5,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Eraser Size:',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Card(
                          color: Colors.white,
                          elevation: 0,
                          child: Slider(
                            thumbColor: Colors.blue,
                            activeColor: Colors.blue,
                            value: erasersize.value,
                            min: 3,
                            max: 8,
                            onChanged: (val) {
                              print(val);
                              erasersize.value = val;
                            },
                            divisions: 5,
                          ),
                        )
                      ],
                    ),
                    const Divider(),
                    Text(
                      'Made by Oma',
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
