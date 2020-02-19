import 'dart:async';

import 'package:flutter/material.dart';

class Binary extends StatelessWidget {
  @override
  Widget build(BuildContext context) => StreamBuilder<DateTime>(
      stream: Stream.periodic(Duration(seconds: 1), (_) => DateTime.now()),
      builder: (BuildContext context, AsyncSnapshot<DateTime> snapshot) =>
          Scaffold(
              appBar: AppBar(title: Text('Binary Clock')),
              body: Center(
                  child: CustomPaint(
                size: Size(MediaQuery.of(context).size.width * 0.8,
                    MediaQuery.of(context).size.width * 0.6),
                painter:
                    _BinaryPainter.fromTime(snapshot.data ?? DateTime.now()),
              ))));
}

class _BinaryPainter extends CustomPainter {
  _BinaryPainter(this.hours, this.minutes, this.seconds);
  final int hours;
  final int minutes;
  final int seconds;

  factory _BinaryPainter.fromTime(DateTime time) =>
      _BinaryPainter(time.hour, time.minute, time.second);

  String toFixed(int temp) => '00$temp'.substring('00$temp'.length - 2);

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final paint = Paint()
      ..color = Colors.green[600]
      ..strokeWidth = width / 150
      ..style = PaintingStyle.stroke;
    final fillPaint = Paint()..color = Colors.green[600];
    final List<double> colOffset = [
      height * 0.26,
      height * 0.426,
      height * 0.592,
      height * 0.76
    ];
    final hourPainter = TextPainter(
        text: TextSpan(text: 'hour', style: TextStyle(color: Colors.black)),
        textScaleFactor: size.width / 200,
        textDirection: TextDirection.ltr)
      ..layout();
    hourPainter.paint(canvas, Offset(width * 0.06, height * 0.05));
    final minutePainter = TextPainter(
        text: TextSpan(text: 'min', style: TextStyle(color: Colors.black)),
        textScaleFactor: size.width / 200,
        textDirection: TextDirection.ltr)
      ..layout();
    minutePainter.paint(canvas, Offset(width * 0.32, height * 0.05));
    final secondPainter = TextPainter(
        text: TextSpan(text: 'sec', style: TextStyle(color: Colors.black)),
        textScaleFactor: size.width / 200,
        textDirection: TextDirection.ltr)
      ..layout();
    secondPainter.paint(canvas, Offset(width * 0.57, height * 0.05));
    final hPainter = TextPainter(
        text: TextSpan(
            text: toFixed(hours),
            style: TextStyle(
                letterSpacing: width * 0.05, color: Colors.blue[800])),
        textScaleFactor: size.width / 200,
        textDirection: TextDirection.ltr)
      ..layout();
    hPainter.paint(canvas, Offset(width * 0.033, height * 0.85));
    final mPainter = TextPainter(
        text: TextSpan(
            text: toFixed(minutes),
            style: TextStyle(
                letterSpacing: width * 0.05, color: Colors.blue[800])),
        textScaleFactor: size.width / 200,
        textDirection: TextDirection.ltr)
      ..layout();
    mPainter.paint(canvas, Offset(width * 0.293, height * 0.85));
    final sPainter = TextPainter(
        text: TextSpan(
            text: toFixed(seconds),
            style: TextStyle(
                letterSpacing: width * 0.05, color: Colors.blue[800])),
        textScaleFactor: size.width / 200,
        textDirection: TextDirection.ltr)
      ..layout();
    sPainter.paint(canvas, Offset(width * 0.537, height * 0.85));
    final onePainter = TextPainter(
        text: TextSpan(
            text: '1',
            style:
                TextStyle(letterSpacing: width * 0.05, color: Colors.red[600])),
        textScaleFactor: size.width / 200,
        textDirection: TextDirection.ltr)
      ..layout();
    onePainter.paint(canvas, Offset(width * 0.78, height * 0.71));
    final twoPainter = TextPainter(
        text: TextSpan(
            text: '2',
            style:
                TextStyle(letterSpacing: width * 0.05, color: Colors.red[600])),
        textScaleFactor: size.width / 200,
        textDirection: TextDirection.ltr)
      ..layout();
    twoPainter.paint(canvas, Offset(width * 0.78, height * 0.535));
    final fourPainter = TextPainter(
        text: TextSpan(
            text: '4',
            style:
                TextStyle(letterSpacing: width * 0.05, color: Colors.red[600])),
        textScaleFactor: size.width / 200,
        textDirection: TextDirection.ltr)
      ..layout();
    fourPainter.paint(canvas, Offset(width * 0.78, height * 0.37));
    final eightPainter = TextPainter(
        text: TextSpan(
            text: '8',
            style:
                TextStyle(letterSpacing: width * 0.05, color: Colors.red[600])),
        textScaleFactor: size.width / 200,
        textDirection: TextDirection.ltr)
      ..layout();
    eightPainter.paint(canvas, Offset(width * 0.78, height * 0.205));
    canvas.drawLine(Offset(0, 0), Offset(width, 0), paint);
    canvas.drawLine(Offset(0, height), Offset(width, height), paint);
    canvas.drawLine(Offset(width, 0), Offset(width, height), paint);
    canvas.drawLine(Offset(0, 0), Offset(0, height), paint);
    canvas.drawLine(Offset(width / 4, 0), Offset(width / 4, height), paint);
    canvas.drawLine(
        Offset(2 * width / 4, 0), Offset(2 * width / 4, height), paint);
    canvas.drawLine(
        Offset(3 * width / 4, 0), Offset(3 * width / 4, height), paint);
    for (var i = 0; i < 3; i++) {
      final numberToRender = [hours, minutes, seconds][i];
      final firstPlace =
          '0000${(numberToRender / 10).truncate().toRadixString(2)}';
      final secondPlace = '0000${(numberToRender % 10).toRadixString(2)}';
      for (var y = 0; y < 4; y++) {
        final yOffset = colOffset[y];
        if ((i != 0 && y > 0) || y > 1) {
          canvas.drawRect(
              Rect.fromCircle(
                  center: Offset(i * width / 4 + width * 0.08, yOffset),
                  radius: width * 0.03),
              shouldFill(firstPlace, y) ? fillPaint : paint);
        }
        canvas.drawRect(
            Rect.fromCircle(
                center: Offset(i * width / 4 + width * 0.17, yOffset),
                radius: width * 0.03),
            shouldFill(secondPlace, y) ? fillPaint : paint);
      }
    }
  }

  bool shouldFill(String binary, int place) =>
      binary.substring(binary.length - 4).codeUnitAt(place) == 49;

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
