import 'package:flutter/material.dart';
import 'package:hello/model/words_model.dart';
import 'package:hello/services/tts_service.dart';

class SpeakDemo extends StatefulWidget {
  const SpeakDemo({@required this.readingWord, key}) : super(key: key);

  final ReadingWord readingWord;

  @override
  _SpeakDemoState createState() => _SpeakDemoState();
}

class _SpeakDemoState extends State<SpeakDemo> {
  @override
  void initState() {
    super.initState();
    parts = widget.readingWord.syllables.split(" ");
  }

  List<String> parts;

  final Map<dynamic, dynamic> practiceWord = {
    "word": "graduation",
    "phonemes": ["graw", "dew", "ation"],
    "parts": ["gra", "du", "ation"]
  };

  TtsService _ttsService = TtsService();

  int index = 0;

  Future _speak(var pWord) async {
    String _fullWord = widget.readingWord.word;

    List<String> phonemes = widget.readingWord.syllablesPron.split(" ");
    setState(() {
      gap = true;
      highlightPart = true;
    });
    index = 0;
    for (var word in phonemes) {
      _ttsService.setSpeechRate(0.6);
      if (word.isNotEmpty) {
        await _ttsService.speak(word);
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

    _ttsService.setSpeechRate(0.65);
    if (_fullWord.isNotEmpty) {
      await _ttsService.speak(_fullWord);
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
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 300,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.cyan),
          borderRadius: BorderRadius.circular(20)),
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
                                : Theme.of(context).accentColor),
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
