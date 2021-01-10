import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hello/progress.dart';
import 'package:hello/tic_tac.dart';
import 'package:hello/typing.dart';
import 'package:hello/words.dart';

class Assessment extends StatefulWidget {
  @override
  _AssessmentState createState() => _AssessmentState();
}

class _AssessmentState extends State<Assessment> {
  PageController _pageController =
      PageController(initialPage: 0, viewportFraction: 0.8);

  int currentPage = 0;

  int asmtType; //

  List<IconData> icons = [
    Icons.child_care,
    Icons.face,
    FontAwesomeIcons.lightbulb
  ];

  List<String> stages = ["Beginner", "Intermediate", "Advanced"];
  List<String> levels = ["Level 1", "Level 2", "Level 3", "Level 4", "Level 5"];

  @override
  Widget build(BuildContext context) {
    asmtType = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        backgroundColor: Colors.amber[300],
        appBar: AppBar(
          toolbarHeight: 65,
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Text(
              (asmtType == 1
                  ? "Reading \n${stages.elementAt(currentPage)}"
                  : "Typing \n${stages.elementAt(currentPage)}"),
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800]),
              textAlign: TextAlign.center,
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
              child: LevelHome(
                stage: stages.elementAt(currentPage),
                type: asmtType,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.teal[(currentPage + 1) * 100],
                  border: Border.all(color: Colors.cyan, width: 5.0),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              margin: EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 25),
              height: double.infinity,
              width: double.infinity,
              child: LevelHome(
                stage: stages.elementAt(currentPage),
                type: asmtType,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.teal[(currentPage + 1) * 100],
                  border: Border.all(color: Colors.orange, width: 5.0),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              margin: EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 25),
              height: double.infinity,
              width: double.infinity,
              child: LevelHome(
                stage: stages.elementAt(currentPage),
                type: asmtType,
              ),
            ),
          ],
        ));
  }
}

class LevelHome extends StatelessWidget {
  LevelHome({@required this.stage, @required this.type});
  final String stage;
  final int type;

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

  Object getWords(String e) {
    switch (stage) {
      case "Beginner":
        return Rwords.beginner.elementAt(levels.indexOf(e));
        break;
      case "Intermediate":
        return Rwords.intermediate.elementAt(levels.indexOf(e));
        break;
      case "Advanced":
        return Rwords.advanced.elementAt(levels.indexOf(e));
        break;
    }

    return "return";
  }

  void showWarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // shape: StadiumBorder(),
          title: Text(
            "Warning..!!!",
            textAlign: TextAlign.center,
          ),
          content: Text(
            "Please complete previous levels..!!",
            textAlign: TextAlign.center,
          ),
          actions: [
            RaisedButton(
                child: Text("OK"), onPressed: () => Navigator.pop(context))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: levels
          .map((elem) => GestureDetector(
                child: Container(
                    padding: EdgeInsets.all(10),
                    height: 70,
                    decoration: BoxDecoration(
                        color: _colors[levels.indexOf(elem)],
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    margin: EdgeInsets.all(15),
                    width: double.infinity,
                    child: Center(
                        child: Text(
                      elem,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ))),
                onTap: () {
                  print("$stage - $elem");
                  if (UserProgress.currentLevel < (levels.indexOf(elem) + 1) ||
                      UserProgress.currentStage < (stages.indexOf(stage) + 1))
                    showWarning(context);
                  else
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                (type == 1 ? TicTac() : TypingAssessment()),
                            settings:
                                RouteSettings(arguments: getWords(elem))));
                },
              ))
          .toList(),
    ));
  }
}
