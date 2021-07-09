import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SpeakDemo extends StatefulWidget {
  const SpeakDemo({key}) : super(key: key);

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

    parts = practiceWord["parts"];

    flutterTts.setStartHandler(() {
      print("speaking");

      setState(() {
        isSpeaking = true;
      });
    });

    flutterTts.setCompletionHandler(() {
      print("COmpleted");
      setState(() {
        isSpeaking = false;
      });
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

  bool isSpeaking = false;

  int index = 0;

  Future _speak(var pWord) async {
    flutterTts.setPitch(pitch);
    flutterTts.setVolume(volume);

    String _fullWord = pWord["word"];

    List<String> phonemes = pWord["phonemes"];

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

    flutterTts.setSpeechRate(rate);
    if (_fullWord.isNotEmpty) {
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak(_fullWord);
    }
    setState(() {
      index = 0;
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Speak demo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: isSpeaking ? 10.0 : 0,
              children: parts
                  .map((txt) => Text(
                        txt,
                        style: TextStyle(
                            fontSize:
                                (index == parts.indexOf(txt) && isSpeaking)
                                    ? 45
                                    : 35,
                            color: ((index == parts.indexOf(txt) && isSpeaking)
                                ? Colors.yellow
                                : Colors.white),
                            fontWeight: FontWeight.bold),
                      ))
                  .toList(),
            ),
            ElevatedButton(
              child: Text("Speak"),
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
