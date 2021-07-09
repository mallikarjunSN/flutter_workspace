import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hello/custom_widgets/cool_color.dart';

class Speedo extends StatefulWidget {
  const Speedo({key, @required this.value, this.height = 300, this.width = 300})
      : super(key: key);

  final double value;

  final double height;
  final double width;

  @override
  _SpeedoState createState() => _SpeedoState();
}

class MeterBar extends CustomPainter {
  MeterBar({@required this.label});

  final String label;

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;

    double barWidth = width / 10;

    TextPainter textPainter = TextPainter(
      text: TextSpan(text: "", style: TextStyle(color: Colors.amber)),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    // double radius = min(width, height);

    double startAngle = 150.0;
    double sweepAngle = 240.0;

    double centerX = width / 2, centerY = height / 2;

    Offset center = Offset(centerX, centerY);

    Paint curvePaint = Paint()
      ..strokeWidth = barWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      //this restrict this brush to just draw an arc not full circle
      ..shader = LinearGradient(
              colors: [Colors.red, Colors.yellow, Colors.green])
          .createShader(
              Rect.fromCenter(center: center, width: width, height: height));

    canvas.drawArc(
      Rect.fromCenter(
          center: center, width: width - barWidth, height: height - barWidth),
      startAngle * pi / 180,
      sweepAngle * pi / 180,
      false,
      curvePaint,
    );

    Paint paint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..strokeWidth = 2;

    double fontSize = 18;

    int count = 0;
    for (double angle = startAngle;
        angle <= startAngle + sweepAngle + 1;
        angle += 4.8) {
      double milestone = 0;

      var x1, x2, y1, y2;

      if ((count) % 5 == 0) {
        milestone = barWidth * 0.4;
        paint.strokeWidth = 3;

        fontSize = (count == 0 || count == 25 || count == 50
            ? height / 12
            : height / 18);

        textPainter.text = TextSpan(
          text: (count * 2).toString(),
          style: TextStyle(
            color: Colors.white,
            backgroundColor: Colors.black.withOpacity(0.5),
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        );
      } else {
        paint.strokeWidth = 2;
      }

      x1 = centerX + (width - barWidth - milestone) / 2 * cos(angle * pi / 180);
      y1 = centerY + (width - barWidth - milestone) / 2 * sin(angle * pi / 180);
      x2 = centerX + (width / 2) * cos(angle * pi / 180);
      y2 = centerY + (width / 2) * sin(angle * pi / 180);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);

      if (count % 5 == 0) {
        var movFactor = -5.0;
        if (count == 50) {
          movFactor = fontSize * 2;
        } else if (count > 25) {
          movFactor = fontSize + 5;
        } else if (count == 25) movFactor = (fontSize + 5) / 2;

        x1 = centerX + (width - barWidth) / 2.15 * cos(angle * pi / 180);
        y1 = centerY + (width - barWidth) / 2.15 * sin(angle * pi / 180);

        textPainter.layout(minWidth: 0.0, maxWidth: double.maxFinite);
        textPainter.paint(canvas, Offset((x1 - movFactor), (y1 - 5)));
      }

      count += 1;
    }

    fontSize = height / 10;
    textPainter.text = TextSpan(
      text: label,
      style: TextStyle(
        color: Colors.green[500],
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );

    textPainter.layout(minWidth: 0.0, maxWidth: double.maxFinite);
    textPainter.paint(canvas,
        Offset(width / 2 - (fontSize * label.length) / 4, height * 0.25));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _SpeedoState extends State<Speedo> {
  double height, width;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = widget.height;
    width = widget.width;
    return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: height,
                    width: width,
                    child: CustomPaint(
                      painter: MeterBar(label: "Accuracy %"),
                    ),
                  ),
                  Container(
                    height: height / 5,
                    width: width / 5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: CoolColor().getColor(0xc0c0c0),
                    ),
                  ),
                  Positioned(
                    bottom: height / 12,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: widget.value),
                      duration: Duration(milliseconds: 2000),
                      curve: Curves.easeOutCirc,
                      builder: (context, val, child) {
                        return Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.blue[800],
                              border: Border.all(width: 1.5),
                              borderRadius: BorderRadius.circular(15)),
                          child: Text(
                            (val * 100.0).toStringAsFixed(1) + " %",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: height / 9,
                                shadows: [
                                  Shadow(
                                      offset: Offset(-2, 2), color: Colors.grey)
                                ],
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                  ),
                  TweenAnimationBuilder(
                      tween: Tween(
                          begin: -pi * 210 / 180,
                          end: pi * (-210 + (240 * widget.value)) / 180),
                      duration: Duration(milliseconds: 2000),
                      curve: Curves.easeOutCirc,
                      builder: (context, value, child) {
                        return Transform.rotate(
                          angle: value,
                          alignment: Alignment.center,
                          child: child,
                        );
                      },
                      child: Transform.translate(
                        offset: Offset(height / 5, 0),
                        child: Container(
                          height: height / 30,
                          width: width / 2,
                          decoration: BoxDecoration(
                              color: Colors.cyan.withOpacity(0.7),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(height / 20),
                                  bottomRight: Radius.circular(height / 20))),
                        ),
                      )

                      // Divider(
                      //   indent: MediaQuery.of(context).size.width / 2,
                      //   thickness: 7.5,
                      //   endIndent: MediaQuery.of(context).size.width / 10,
                      //   color: Colors.cyan,
                      // ),
                      ),
                ],
              ),
            ],
          ),
        ));
  }
}
