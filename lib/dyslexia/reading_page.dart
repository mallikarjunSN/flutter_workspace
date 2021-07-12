// import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hello/custom_widgets/anime_button.dart';
import 'package:hello/dyslexia/speak.dart';
import 'package:hello/model/user_progress.dart';
import 'package:hello/model/words_model.dart';
import 'package:hello/services/db_service.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:string_similarity/string_similarity.dart';

class ReadingPage extends StatefulWidget {
  ReadingPage({
    @required this.readingWord,
  });
  final ReadingWord readingWord;

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

  void updateProgress(double accuracy) async {
    Map<String, dynamic> data = widget.readingWord.toJson();
    data["lastAccuracy"] = accuracy;
    data["lastAttemptOn"] = DateTime.now().toIso8601String();
    await DatabaseService().updateAttempt("readingWords", data);
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
          SpeakDemo(
            readingWord: widget.readingWord,
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
          AnimeButton(
            width: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Submit",
                  style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.greenAccent),
                  child: Icon(
                    Icons.done,
                    color: Colors.white,
                    size: 25,
                  ),
                )
              ],
            ),
            onPressed: () {
              updateProgress(accuracy);
            },
            // color: Colors.amber,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    originalWord = ModalRoute.of(context).settings.arguments;
    // print(widget.readingWord.lastAttemptOn);
    return Scaffold(
        body: _hasSpeech
            ? getUI()
            : Center(
                child: Text("Please Enable the permission for audio"),
              ));
  }
}
