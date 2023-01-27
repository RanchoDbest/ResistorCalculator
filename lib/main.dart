import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:resistance_calculator/myPainter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
	    debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Resistance Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var arr = [];

  List<Color> digitColors = [
    Colors.black,
    Colors.brown,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Color(0xffEE82EE),
    Colors.grey,
    Colors.white,
  ];

  List<Color> multiplierColors = [
    Colors.black,
    Colors.brown,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Color(0xffEE82EE),
    Colors.grey,
    Colors.white,
    Color(0xffFFD700),
    Color(0xffC0C0C0),
  ];

  List<Color> toleranceColors = [
	  Colors.brown,
	  Colors.red,
	  Colors.orange,
	  Colors.yellow,
	  Colors.green,
	  Colors.blue,
	  Color(0xffEE82EE),
	  Colors.grey,
	  Color(0xffFFD700),
	  Color(0xffC0C0C0),
  ];

  Map digits = {
    Colors.black: '0',
    Colors.brown: '1',
    Colors.red: '2',
    Colors.orange: '3',
    Colors.yellow: '4',
    Colors.green: '5',
    Colors.blue: '6',
    Color(0xffEE82EE): '7',
    Colors.grey[700]: '8',
    Colors.white: '9',
  };

  Map tolerances = {
    Colors.brown: 1,
    Colors.red: 2,
    Colors.green: 0.5,
    Colors.blue: 0.25,
    Color(0xffEE82EE): 0.1,
    Colors.grey[700]: 0.05,
    Color(0xffFFD700): 5,
    Color(0xffC0C0C0): 10,
  };

  Map multipliers = {
    Colors.black: 1,
    Colors.brown: 10,
    Colors.red: 100,
    Colors.orange: 1000,
    Colors.yellow: 10000,
    Colors.green: 1000000,
    Colors.blue: 1000000,
    Color(0xffEE82EE): 10000000,
    Colors.grey[700]: 100000000,
    Colors.white: 1000000000,
    Color(0xffFFD700): 0.1,
    Color(0xffC0C0C0): 0.01,
  };

  bool isImageloaded = false;
  double factorW = 1;
  double factorH = 1;
  late ui.Image image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    init();

    for (var i = 0; i <= 4; i++) {
      if (i < 3) {
        arr.add(Colors.black);
      } else {
        arr.add(Color(0xffFFD700));
      }
    }
  }

  Future<Null> init() async {
    final ByteData data = await rootBundle.load('assets/images/0.png');
    image = await loadImage(Uint8List.view(data.buffer));
  }

  // Loads image as byte code for CustomPainter to understand
  Future<ui.Image> loadImage(img) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      setState(() {
        isImageloaded = true;
      });
      return completer.complete(img);
    });
    return completer.future;
  }

  Map getColorsRes(Color a, Color b, Color c, Color d) {
    Map combination = {
      'D1': new Paint()
        ..color = a
        ..style = PaintingStyle.fill,
      'D2': new Paint()
        ..color = b
        ..style = PaintingStyle.fill,
      'Multiplier': new Paint()
        ..color = c
        ..style = PaintingStyle.fill,
      'Tolerance': new Paint()
        ..color = d
        ..style = PaintingStyle.fill,
    };
    return combination;
  }

  void _openColorPicker(int button, List<Color> colors) async {
    _openDialog(
      "Color picker",
      BlockPicker(
        pickerColor: Colors.black,
        availableColors: colors,
        onColorChanged: (color) {
          setState(() {
            arr[button] = color;
          });
        },
      ),
    );
  }

  // Widget to show dialog for color picker
  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.grey[300],
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            FlatButton(
              child: Text('CANCEL'),
              onPressed: Navigator.of(context).pop,
            ),
            FlatButton(
              child: Text('SUBMIT'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Combines answer to be displayed on screen
  String getAnswer() {
    String digitValue;
    int tolerance = tolerances[arr[3]];

    digitValue = "${digits[arr[0]]}${digits[arr[1]]}";

    double resistance = double.parse(digitValue) * multipliers[arr[2]];

    return "${resistance.toStringAsFixed(0) + "Ω" " ± " + tolerance.toString() + "%"}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Tolerance =',
                  style: TextStyle(fontSize: 30, color: Colors.black),
                ),
                Text(
                  getAnswer(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.red,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            (isImageloaded)
                ? FittedBox(
                    child: SizedBox(
                      width: image.width.toDouble() * factorW,
                      height: image.height.toDouble() * factorH,
                      child: CustomPaint(
                        painter: myPainter(
                          image: image,
                          factorW: factorW,
                          factorH: factorH,
                          color: getColorsRes(arr[0], arr[1], arr[2], arr[3]),
                        ),
                      ),
                    ),
                  )
                : Text('image is not loaded'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Band\n1",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      FloatingActionButton(
                        heroTag: 'D1',
                        onPressed: () {
                          _openColorPicker(0, digitColors);
                        },
                        backgroundColor: arr[0],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Band\n2",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      FloatingActionButton(
                        heroTag: 'D2',
                        onPressed: () {
                          _openColorPicker(1, digitColors);
                        },
                        backgroundColor: arr[1],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    Text(
                      "Multiplier\nBand",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    FloatingActionButton(
                      heroTag: 'D4',
                      onPressed: () {
                        _openColorPicker(2, multiplierColors);
                      },
                      backgroundColor: arr[2],
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      'Tolerance\nBand',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    FloatingActionButton(
                      heroTag: 'D5',
                      onPressed: () {
                        _openColorPicker(3, toleranceColors);
                      },
                      backgroundColor: arr[3],
                    ),
                  ],
                )
              ],
            ),
          ]),
        ));
  }
}
