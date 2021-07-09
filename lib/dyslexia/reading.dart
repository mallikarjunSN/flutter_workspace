import 'package:flutter/material.dart';
import 'package:hello/dyslexia/reading_page.dart';
import 'package:hello/model/user_progress.dart';

class ReadingAssessment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ReadingAssessmentState();
  }
}

class ReadingAssessmentState extends State<ReadingAssessment> {
  String message;

  List<String> words;

  @override
  Widget build(BuildContext context) {
    words = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Align(
            child: Text("Reading assessments"),
          ),
        ),
        body: Center(
          child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: words.length,
              itemBuilder: (context, index) {
                return Container(
                  alignment: Alignment.center,
                  color:
                      (UserProgress.attempts.containsKey(words.elementAt(index))
                          ? Colors.green[(index + 3) % 10 * 100]
                          : Colors.blue[(index + 3) % 10 * 100]),
                  height: 120,
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  padding: EdgeInsets.all(10),
                  child: Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          words.elementAt(index),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      FloatingActionButton(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.mic,
                          color: Colors.blue,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReadingPage(),
                                  settings:
                                      RouteSettings(arguments: words[index])));
                        },
                        heroTag: null,
                      ),
                    ],
                  ),
                );
              }),
        ));
  }
}
