import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hello/custom_widgets/cool_color.dart';

class Progress extends StatefulWidget {
  final Widget child;

  Progress({Key key, this.child}) : super(key: key);

  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  List<FlSpot> data = [FlSpot(0, 45.0)];
  _ProgressState() {
    for (var i = 1; i <= 25; i++) {
      data.add(FlSpot(i.toDouble(), (i < 20 ? 60.0 + i * 1.5 : 88.0)));
    }
  }

  double height, width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Center(
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                  color: CoolColor.primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  )),
              child: Center(
                child: Text(
                  "Exercises Progress",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: height * 0.16,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 300,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                color: const Color(0xff020227).withOpacity(0.75),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: LineChart(
                    LineChartData(
                      minX: 0,
                      maxX: 25,
                      minY: 0.0,
                      maxY: 100.0,
                      titlesData: LineTitles.getTitleData(),
                      gridData: FlGridData(
                        show: true,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.white.withOpacity(0.5),
                            // color: const Color(0xff37434d),
                            strokeWidth: 1,
                          );
                        },
                        drawVerticalLine: true,
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: Colors.white.withOpacity(0.5),
                            // color: const Color(0xff37434d),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                            // color: const Color(0xff37434d),
                            width: 1),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: data,
                          isCurved: true,
                          colors: [Colors.cyan],
                          barWidth: 4,
                          // dotData: FlDotData(show: false),
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            colors: [Colors.cyan]
                                .map((color) => color.withOpacity(0.3))
                                .toList(),
                          ),
                        ),
                      ],
                      axisTitleData: FlAxisTitleData(
                        bottomTitle: AxisTitle(
                          showTitle: true,
                          titleText: "No. of Attempts",
                          reservedSize: 16,
                          margin: 0,
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        leftTitle: AxisTitle(
                          showTitle: true,
                          titleText: "Accuracy %",
                          reservedSize: 16,
                          margin: 0,
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    swapAnimationCurve: Curves.bounceOut,
                    swapAnimationDuration: Duration(milliseconds: 5000),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              width: width,
              child: Container(
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Total words attempted",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Reading : 20\nTyping : 15",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Divider(
                      thickness: 1.5,
                    ),
                    Text(
                      "Average Accuracy",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 70,
                      width: 70,
                      child: Stack(
                        fit: StackFit.expand,
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: 0.88,
                            backgroundColor: Colors.cyan.withOpacity(0.25),
                            strokeWidth: 6,
                          ),
                          Center(
                              child: Text(
                            "88.5 %",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ))
                        ],
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}

class LineTitles {
  static getTitleData() => FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 35,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff68737d),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 5,
          interval: 5,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            if (value % 20 == 0) {
              return value.toString();
            }
            return '';
          },
          reservedSize: 35,
          margin: 5,
        ),
      );
}
