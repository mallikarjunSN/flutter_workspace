import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hello/model/words_model.dart';

class SpeakDemo extends StatefulWidget {
  const SpeakDemo({@required this.readingWord, key}) : super(key: key);

  final ReadingWord readingWord;

  @override
  _SpeakDemoState createState() => _SpeakDemoState();
}

class _SpeakDemoState extends State<SpeakDemo> {
  double rate = 1.0;
  double pitch = 1.0;
  double volume = 0.7;

  FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();
    _initFlutterTts();
  }

  List<String> parts;

  void _initFlutterTts() {
    flutterTts = FlutterTts();

    parts = widget.readingWord.syllables.split(" ");

    flutterTts.setStartHandler(() {
      print("speaking");
    });

    flutterTts.setCompletionHandler(() {
      print("COmpleted");
    });

    flutterTts.setCancelHandler(() {
      print("cancelled");
    });

    flutterTts.setPauseHandler(() {
      print("Paused");
    });

    flutterTts.setContinueHandler(() {
      print("continued");
    });
  }

  final Map<dynamic, dynamic> practiceWord = {
    "word": "graduation",
    "phonemes": ["graw", "dew", "ation"],
    "parts": ["gra", "du", "ation"]
  };

  int index = 0;

  Future _speak(var pWord) async {
    flutterTts.setPitch(pitch);
    flutterTts.setVolume(volume);

    String _fullWord = widget.readingWord.word;

    List<String> phonemes = widget.readingWord.syllablesPron.split(" ");
    setState(() {
      gap = true;
      highlightPart = true;
    });
    index = 0;
    flutterTts.setSpeechRate(rate * 0.8);
    for (var word in phonemes) {
      if (word.isNotEmpty) {
        await flutterTts.awaitSpeakCompletion(true);
        await flutterTts.speak(word);
      }
      setState(() {
        index += 1;
      });
    }

    setState(() {
      gap = false;
      highlightPart = false;
      highlightWhole = true;
    });

    flutterTts.setSpeechRate(rate);
    if (_fullWord.isNotEmpty) {
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak(_fullWord);
    }
    setState(() {
      highlightWhole = false;
    });
  }

  bool highlightPart = false;
  bool highlightWhole = false;
  bool gap = false;

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 300,
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(20)),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: gap ? 10.0 : 0,
              children: parts
                  .map((txt) => Text(
                        txt,
                        style: TextStyle(
                            fontSize: (highlightWhole ||
                                    index == parts.indexOf(txt) &&
                                        highlightPart)
                                ? 40
                                : 30,
                            color: (highlightWhole ||
                                    index == parts.indexOf(txt) && highlightPart
                                ? Colors.amber
                                : Colors.black),
                            fontWeight: FontWeight.bold),
                      ))
                  .toList(),
            ),
            IconButton(
              iconSize: 50,
              color: Colors.cyan,
              icon: SizedBox(
                  height: 70,
                  width: 70,
                  child: Image.network(
                    "https://icon-library.com/images/pronunciation-icon/pronunciation-icon-28.jpg",
                    fit: BoxFit.contain,
                  )),
              onPressed: () {
                _speak(practiceWord);
              },
            ),
          ],
        ),
      ),
    );
  }
}
