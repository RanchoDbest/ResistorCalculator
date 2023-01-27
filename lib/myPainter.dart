import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:typed_data';

class myPainter extends CustomPainter {
  @override
  myPainter({required this.image, required this.factorW, required this.factorH, required this.color});

  var image;
  double factorW;
  double factorH;
  double offsetX = -1.5;
  double offsetY = 0;
  Map color;


  // Painter function that draws is in charge of drawing the image of the resistor and the bar colors
  void paint(Canvas canvas, Size size) {
    final Paint painter = new Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    // TODO: draw something with canvas
    canvas.drawImage(image, Offset(offsetX, offsetY), Paint());

    //1st bar
    canvas.drawRect(Rect.fromLTRB(
	    offsetX + size.width * (161 / 539) / factorW,
	    offsetY + size.height * (6 / 140) / factorH,
	    offsetX + size.width * (179 / 539) / factorW,
	    offsetY + size.height * (106 / 140) / factorH), color['D1']);
    //2nd bar
    canvas.drawRect(Rect.fromLTRB(
	    offsetX + size.width * (201 / 539) / factorW,
	    offsetY + size.height * (16 / 140) / factorH,
	    offsetX + size.width * (219 / 539) / factorW,
	    offsetY + size.height * (96 / 140) / factorH), color['D2']);
    //3rd bar
    canvas.drawRect(Rect.fromLTRB(
	    offsetX + size.width * (241 / 539) / factorW,
	    offsetY + size.height * (16 / 140) / factorH,
	    offsetX + size.width * (259 / 539) / factorW,
	    offsetY + size.height * (96 / 140) / factorH), color['Multiplier']);
    //5th bar
    canvas.drawRect(Rect.fromLTRB(
	    offsetX + size.width * (321 / 539) / factorW,
	    offsetY + size.height * (16 / 140) / factorH,
	    offsetX + size.width * (339 / 539) / factorW,
	    offsetY + size.height * (96 / 140) / factorH), color['Tolerance']);
  }

  // repaint function in case Painter needs to update
  @override
  bool shouldRepaint(myPainter oldDelegate) {
    return false;
  }
}