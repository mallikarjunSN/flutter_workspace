import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hello/custom_widgets/cool_color.dart';
import 'package:hello/model/user_progress.dart';
import 'package:hello/services/db_service.dart';

class ProgressUI extends StatefulWidget {
  final Widget child;

  ProgressUI({Key key, this.child}) : super(key: key);

  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<ProgressUI> {
  double height, width;

  int interval;

  List<Progress> filter(List<Progress> pd) {
    List<Progress> filteredData = [];
    return pd;
  }

  int totalWordsCount = 0;

  double averageAccuracy = 0.0;
  double totalAccuracy = 0.0;

  List<FlSpot> getChartData(List<Progress> lp) {
    List<FlSpot> data = [FlSpot(0, 0.0)];
    int i = 1;
    totalAccuracy = 0.0;
    averageAccuracy = 0.0;
    for (var item in lp) {
      print(item.lastAccuracy);
      totalAccuracy += item.lastAccuracy;
      data.add(FlSpot((i).toDouble(), (totalAccuracy / i)));
      i++;
    }
    averageAccuracy = totalAccuracy / i;
    return data;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Center(
      child: FutureBuilder(
          future: DatabaseService().getProgressDetails(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Progress> progressData = snapshot.data;
              List<Progress> selectedData = filter(progressData);
              interval =
                  (selectedData.length > 6 ? selectedData.length ~/ 6 : 1);
              return Stack(
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
                    top: height * 0.14,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      height: 300,
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 20, bottom: 20, right: 10, left: 5),
                        color: const Color(0xff020227).withOpacity(0.75),
                        child: LineChart(
                          LineChartData(
                            minX: 0,
                            maxX: selectedData.length.toDouble(),
                            minY: 0,
                            maxY: 100,
                            titlesData: LineTitles.getTitleData(interval),
                            gridData: FlGridData(
                              show: true,
                              getDrawingHorizontalLine: (value) {
                                if (value % 20 == 0) {
                                  return FlLine(
                                    strokeWidth: 0.7,
                                    color: Colors.white.withOpacity(0.5),
                                  );
                                } else
                                  return FlLine(
                                    strokeWidth: 0,
                                  );
                              },
                              drawVerticalLine: false,
                              getDrawingVerticalLine: (value) {
                                return FlLine(
                                  color: Colors.white.withOpacity(0.5),
                                  strokeWidth: 1,
                                );
                              },
                            ),
                            borderData: FlBorderData(
                              show: true,
                              border: Border(
                                left: BorderSide(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 2,
                                ),
                                bottom: BorderSide(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 2.0,
                                ),
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: getChartData(selectedData),
                                isCurved: true,
                                colors: [
                                  Colors.orange,
                                  Colors.yellow,
                                  Colors.green,
                                  Colors.blue,
                                ],
                                preventCurveOverShooting: true,
                                barWidth: 3,
                                dotData: FlDotData(
                                  show: true,
                                  checkToShowDot: (spot, barData) {
                                    if (spot.x % interval == 0) {
                                      return true;
                                    } else {
                                      return false;
                                    }
                                  },
                                  // getDotPainter: (a, b, c, d) => FlDotPainter(),
                                ),
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
                                titleText: "Number of attempts",
                                textStyle: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              leftTitle: AxisTitle(
                                showTitle: true,
                                titleText: "Average accuracy (%)",
                                reservedSize: 16,
                                margin: 0,
                                textStyle: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                          swapAnimationCurve: Curves.bounceOut,
                          swapAnimationDuration: Duration(milliseconds: 5000),
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
                              progressData.length.toString(),
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
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
                                    backgroundColor:
                                        Colors.cyan.withOpacity(0.25),
                                    strokeWidth: 6,
                                  ),
                                  Center(
                                      child: Text(
                                    "",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ))
                ],
              );
            } else if (snapshot.hasError) {
              print(snapshot.error.toString());
              return Text("some error");
            }
            return CircularProgressIndicator();
          }),
    );
  }
}

class LineTitles {
  static getTitleData(int interval) {
    return FlTitlesData(
      show: true,
      bottomTitles: SideTitles(
        showTitles: true,
        getTextStyles: (value) => const TextStyle(
          color: Color(0xff68737d),
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        interval: interval.toDouble(),
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
            return value.round().toString();
          }
          return '';
        },
      ),
    );
  }
}
