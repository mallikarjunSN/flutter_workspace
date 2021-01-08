import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hello/tic_tac.dart';

class Assessment extends StatefulWidget {
  @override
  _AssessmentState createState() => _AssessmentState();
}

class _AssessmentState extends State<Assessment> {
  PageController _pageController =
      PageController(initialPage: 0, viewportFraction: 0.8);

  int currentPage = 0;

  List<IconData> icons = [
    Icons.child_care,
    Icons.face,
    FontAwesomeIcons.lightbulb
  ];

  List<String> stages = ["Beginner", "Intermediate", "Advanced"];
  List<String> levels = ["Level 1", "Level 2", "Level 3", "Level 4", "Level 5"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber[300],
        appBar: AppBar(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Text(
              stages.elementAt(currentPage),
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800]),
            ),
            Icon(
              icons.elementAt(currentPage),
              size: 40,
              color: Colors.deepOrange[900],
            )
          ]),
          backgroundColor: Colors.transparent,
        ),
        body: PageView(
          onPageChanged: (pageno) {
            setState(() {
              currentPage = pageno;
            });
          },
          controller: _pageController,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.teal[(currentPage + 1) * 100],
                  border: Border.all(color: Colors.cyan, width: 5.0),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              margin: EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 25),
              height: double.infinity,
              width: double.infinity,
              child: LevelHome(stage: stages.elementAt(currentPage)),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.teal[(currentPage + 1) * 100],
                  border: Border.all(color: Colors.cyan, width: 5.0),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              margin: EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 25),
              height: double.infinity,
              width: double.infinity,
              child: LevelHome(stage: stages.elementAt(currentPage)),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.teal[(currentPage + 1) * 100],
                  border: Border.all(color: Colors.orange, width: 5.0),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              margin: EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 25),
              height: double.infinity,
              width: double.infinity,
              child: LevelHome(stage: stages.elementAt(currentPage)),
            ),
          ],
        ));
  }
}

class LevelHome extends StatelessWidget {
  LevelHome({@required this.stage});
  final String stage;

  final List<Color> _colors = [
    Colors.blue[600],
    Colors.green,
    Colors.red,
    Colors.yellow[800],
    Colors.cyan[800]
  ];

  final List<String> stages = ["Beginner", "Intermediate", "Advanced"];
  final List<String> levels = [
    "Level 1",
    "Level 2",
    "Level 3",
    "Level 4",
    "Level 5"
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: levels
          .map((e) => GestureDetector(
                child: Container(
                    padding: EdgeInsets.all(10),
                    height: 70,
                    decoration: BoxDecoration(
                        color: _colors[levels.indexOf(e)],
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    margin: EdgeInsets.all(15),
                    width: double.infinity,
                    child: Center(
                        child: Text(
                      e,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ))),
                onTap: () {
                  print("$stage - $e");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TicTac(),
                          settings: RouteSettings(arguments: "Hello")));
                },
              ))
          .toList(),
    ));
  }
}
