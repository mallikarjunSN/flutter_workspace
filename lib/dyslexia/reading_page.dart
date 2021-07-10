// import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hello/dyslexia/speak.dart';
import 'package:hello/model/user_progress.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:string_similarity/string_similarity.dart';

class ReadingPage extends StatefulWidget {
  @override
  _ReadingPageState createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  String word = "";

  bool _hasSpeech = false;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  final SpeechToText speech = SpeechToText();

  String _text = 'Press the mic button and start speaking';

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
      accuracy = StringSimilarity.compareTwoStrings(
          originalWord.toLowerCase(), _text.toLowerCase());
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
    Navigator.pop(context);
  }

  Widget getUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Text to be spoken",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          SpeakDemo(),
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
                  size: 30,
                ),
              ),
              FloatingActionButton(
                  elevation: 20,
                  backgroundColor: Colors.white,
                  mini: false,
                  heroTag: null,
                  child: Icon(
                    FontAwesomeIcons.microphone,
                    color: Colors.blue,
                    size: 30,
                  ),
                  onPressed: startListening),
              FloatingActionButton(
                elevation: 20,
                heroTag: null,
                backgroundColor: Colors.white,
                onPressed: cancelListening,
                child: Icon(
                  Icons.cancel,
                  color: Colors.blue,
                  size: 30,
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
                    height: 140,
                    width: 140,
                    decoration: BoxDecoration(
                        color: Colors.yellow[800],
                        borderRadius: BorderRadius.all(Radius.circular(70))),
                    child: CircularProgressIndicator(
                      value: accuracy,
                      strokeWidth: 15,
                      backgroundColor: Colors.grey.shade400,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Accuracy\n ${(accuracy * 100).toStringAsPrecision(3)} %",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(speech.isListening ? "Listening" : "Not listening"),
          Container(
            height: 50,
            width: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40))),
            child: ElevatedButton(
              child: Text(
                "submit",
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                updateProgress(accuracy);
              },
              // color: Colors.amber,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    originalWord = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        body: _hasSpeech
            ? getUI()
            : Center(
                child: Text("Please Enable the permission for audio"),
              ));
  }
}
