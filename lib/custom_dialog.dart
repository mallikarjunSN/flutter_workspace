// import 'package:avatar_glow/avatar_glow.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hello/progress.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:string_similarity/string_similarity.dart';

class CustomDialog extends StatefulWidget {
  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  String word = "";

  bool _hasSpeech = false;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  final SpeechToText speech = SpeechToText();

  String _text = 'Press the button and start speaking';

  @override
  void initState() {
    super.initState();
    initSpeechState();
  }

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );

    if (!mounted) return;
    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  void startListening() {
    lastError = "";
    lastWords = "";
    speech.listen(onResult: resultListener);
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
      _text = lastWords;
    });
    comaparision();
  }

  void comaparision() {
    setState(() {
      accuracy = StringSimilarity.compareTwoStrings(originalWord, _text);
      // accuracy = accuracy.
    });
  }

  void stopListening() {
    speech.stop();
    setState(() {});
  }

  void cancelListening() {
    speech.cancel();
    setState(() {});
  }

  void errorListener(SpeechRecognitionError error) {
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    setState(() {
      lastStatus = "$status";
    });
  }

  String originalWord;
  double accuracy = 0;

  UserProgress up = UserProgress();

  void updateProgress(double accuracy) {
    Attempt attempt = Attempt(originalWord, lastWords, accuracy);
    // try {
    if (UserProgress.attempts.containsKey(originalWord) == false) {
      UserProgress.attempts.putIfAbsent(originalWord, () => attempt);
      print("present");
    } else {
      UserProgress.attempts.update(originalWord, (value) => attempt);
      print("absent");
    }
    // } catch (e) {
    //   print(e);
    // }

    // UserProgress.attempts.forEach((key, value) {
    //   print("$key : ${value.accuracy}\n");
    // });
    UserProgress.update();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    originalWord = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text('Confidence'),
          centerTitle: true,
        ),
        body: _hasSpeech
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Text to be spoken",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.1,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.cyan,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Text(
                        originalWord,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow[800]),
                      ),
                    ),
                    Container(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        FloatingActionButton(
                          elevation: 20,
                          heroTag: null,
                          backgroundColor: Colors.white,
                          onPressed: stopListening,
                          child: Icon(
                            Icons.stop,
                            color: Colors.blue,
                          ),
                        ),
                        AvatarGlow(
                          endRadius: 60,
                          animate: speech.isListening,
                          glowColor: Colors.red,
                          duration: Duration(milliseconds: 1000),
                          child: FloatingActionButton(
                              elevation: 20,
                              backgroundColor: Colors.white,
                              mini: false,
                              heroTag: null,
                              child: Icon(
                                FontAwesomeIcons.microphone,
                                color: Colors.blue,
                                size: 25,
                              ),
                              onPressed: startListening),
                        ),
                        FloatingActionButton(
                          elevation: 20,
                          heroTag: null,
                          backgroundColor: Colors.white,
                          onPressed: cancelListening,
                          child: Icon(
                            Icons.cancel,
                            color: Colors.blue,
                          ),
                        )
                      ],
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      _text,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Center(
                            child: Container(
                              height: 150,
                              width: 150,
                              // color: Colors.yellow,
                              decoration: BoxDecoration(
                                  color: Colors.yellow[800],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(75))),
                              child: CircularProgressIndicator(
                                value: accuracy,
                                strokeWidth: 15,
                                backgroundColor: Colors.grey.shade400,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              "${(accuracy * 100).toStringAsPrecision(3)} %",
                              style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                    Text(accuracy.toStringAsPrecision(3)),
                    SizedBox(
                      height: 10,
                    ),
                    Text(speech.isListening ? "Listening" : "Not listening"),
                    RaisedButton(
                        child: Text("submit"),
                        onPressed: () {
                          updateProgress(accuracy);
                        })
                  ],
                ),
              )
            : Center(
                child: Text("Please Enable the permission for audio"),
              ));
  }
}
