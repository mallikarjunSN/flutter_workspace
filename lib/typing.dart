import 'package:flutter/material.dart';
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

  void getWord(BuildContext context, String word) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Enter \n \"$word\"",
            textAlign: TextAlign.center,
          ),
          content: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: Form(
              key: _wordKey,
              child: TextFormField(
                textAlign: TextAlign.center,
                validator: (value) {
                  return (value.isEmpty ? " Please enter the word" : null);
                },
                onChanged: (newValue) {
                  setState(() {
                    enteredWord = newValue;
                  });
                },
              ),
            ),
          ),
          actions: [
            RaisedButton(
              onPressed: () {
                if (_wordKey.currentState.validate()) {
                  print(enteredWord);
                  Navigator.pop(context);
                }
              },
              child: Text("submit"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    words = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Align(
            alignment: Alignment.center,
            child: Text("message"),
          ),
        ),
        body: Center(
          child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: words.length,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.blue[(index + 2) % 10 * 100],
                  height: 100,
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(words.elementAt(index)),
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
