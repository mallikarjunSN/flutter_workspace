import 'package:flutter/material.dart';
import 'package:hello/model/progress.dart';
import 'package:string_similarity/string_similarity.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'custom_dialog.dart';

class TypingAssessment extends StatefulWidget {
  @override
  _TypingAssessmentState createState() => _TypingAssessmentState();
}

class _TypingAssessmentState extends State<TypingAssessment> {
  List<String> words;

  final _wordKey = GlobalKey<FormState>();

  String enteredWord;

  void updateProgress(String originalWord) {
    Attempt attempt = Attempt(originalWord, enteredWord, accuracy);
    if (UserProgress.attempts.containsKey(originalWord) == false) {
      setState(() {
        UserProgress.attempts.putIfAbsent(originalWord, () => attempt);
      });
      print("present");
    } else {
      UserProgress.attempts.update(originalWord, (value) => attempt);
      print("absent");
    }
    setState(() {
      UserProgress.update();
    });
  }

  double accuracy = 0;

  void getWord(BuildContext context, String word) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(
              "Enter \n \"$word\"",
              textAlign: TextAlign.center,
            ),
            content: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Form(
                      key: _wordKey,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        validator: (value) {
                          return (value.isEmpty
                              ? " Please enter the word"
                              : null);
                        },
                        onChanged: (newValue) {
                          setState(() {
                            enteredWord = newValue;
                          });
                        },
                      ),
                    ),
                    Text(
                        "Accuracy - ${(accuracy * 100.0).toStringAsPrecision(3)}")
                  ]),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  if (_wordKey.currentState.validate()) {
                    setState(() {
                      accuracy = StringSimilarity.compareTwoStrings(
                          word.toLowerCase(), enteredWord.toLowerCase());
                    });
                  }
                },
                child: Text("compare"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_wordKey.currentState.validate()) {
                    updateProgress(word);
                    print(enteredWord);
                    setState(() {
                      accuracy = 0;
                    });
                    Navigator.pop(context);
                  }
                },
                child: Text("submit"),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    words = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Typing Assessment",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 25, color: Colors.amberAccent),
          ),
        ),
        body: Center(
          child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: words.length,
              itemBuilder: (context, index) {
                return Container(
                  color:
                      (UserProgress.attempts.containsKey(words.elementAt(index))
                          ? Colors.green[(index + 3) % 10 * 100]
                          : Colors.blue[(index + 3) % 10 * 100]),
                  height: 100,
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        words.elementAt(index),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold),
                      ),
                      FloatingActionButton(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.keyboard,
                          color: Colors.black,
                          size: 35,
                        ),
                        onPressed: () {
                          getWord(context, words.elementAt(index));
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
