// import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hello/custom_widgets/anime_button.dart';
import 'package:hello/custom_widgets/speed.dart';
import 'package:hello/dyslexia/speak.dart';
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
    originalWord = widget.readingWord.word;

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
    print("$originalWord $_text");
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
  double accuracy = 0.0;

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
            style: TextStyle(fontSize: 20),
          ),
          Container(
            child: Speedo(value: accuracy),
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
              updateProgress(accuracy * 100);
            },
            // color: Colors.amber,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _hasSpeech
            ? getUI()
            : Center(
                child: Text("Please Enable the permission for audio"),
              ));
  }
}
