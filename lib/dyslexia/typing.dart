
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hello/custom_widgets/anime_button.dart';
import 'package:hello/custom_widgets/cool_color.dart';
import 'package:hello/custom_widgets/progress_spin.dart';
import 'package:hello/model/words_model.dart';
import 'package:hello/services/db_service.dart';
import 'package:hello/services/tts_service.dart';
import 'package:string_similarity/string_similarity.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'custom_dialog.dart';

class TypingPage extends StatefulWidget {
  TypingPage({@required this.typingWord});
  final TypingWord typingWord;
  @override
  _TypingPageState createState() => _TypingPageState();
}

class _TypingPageState extends State<TypingPage> {
  String enteredWord;

  double accuracy = 0;
  @override
  void initState() {
    super.initState();
    originalWord = widget.typingWord.word;
    initializeColors();
    shuffledWord = shuffle();
  }

  double begin = 0.0, end = 50.0;

  List<bool> matchStatus = [];

  void updateProgress() async {
    Map<String, dynamic> data = widget.typingWord.toJson();
    data["lastAccuracy"] = accuracy * 100.0;
    data["lastAttemptOn"] = DateTime.now().toIso8601String();
    await DatabaseService().updateAttempt("typingWords", data);
    Navigator.pop(context);
  }

  void initializeColors() {
    List<Color> alphaColors = CoolColor().nRandomColors(originalWord.length);
    int i = 0;
    for (var char in originalWord.characters) {
      colorMap.putIfAbsent(char.toString(), () => alphaColors.elementAt(i++));
      matchStatus.add(false);
    }
  }

  String originalWord;

  Map<String, Color> colorMap = {};

  int current = 0;

  List<Widget> displayOriginal() {
    List<Widget> letters = [];

    for (int i = 0; i < originalWord.length; i++) {
      letters.add(Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
                color: (typedWord.length <= i
                    ? Colors.transparent
                    : (matchStatus[i] ? Colors.green : Colors.red)),
                width: 3.0),
          ),
        ),
        child: Text(
          originalWord[i],
          style: TextStyle(
            fontSize: (i == current ? 50 : 25),
            fontWeight: FontWeight.bold,
            color: colorMap[originalWord[i]],
          ),
        ),
      ));
    }

    return letters;
  }

  List<String> shuffle() {
    String temp = originalWord; // + Random();
    List<String> shuffled = temp.characters.map((e) => e).toList();

    shuffled.shuffle();

    return shuffled;
  }

  List<String> shuffledWord = [];

  bool correct = false;

  String typedWord = "";

  List<Widget> getBubbles() {
    List<Widget> bubbles = [];

    for (var i = 0; i < shuffledWord.length; i++) {
      bubbles.add(
        Draggable(
          data: shuffledWord[i],
          child: (Container(
            height: 75,
            width: 75,
            alignment: Alignment.center,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.withOpacity(0.5),
            ),
            child: Text(
              shuffledWord[i],
              style: TextStyle(
                color: colorMap[shuffledWord[i]],
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
          childWhenDragging: Container(),
          feedback: Material(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 75,
              width: 75,
              alignment: Alignment.center,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
              child: Text(
                shuffledWord[i],
                style: TextStyle(
                  color: colorMap[shuffledWord[i]],
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          onDragStarted: () async {
            await TtsService().speak(shuffledWord[i]);
          },
        ),
      );
    }

    return bubbles;
  }

  void onTypingCompleted() {}

  void reset() {
    setState(() {
      current = 0;
      shuffledWord = shuffle();
      matchStatus = matchStatus.map((e) => false).toList();
      typedWord = "";
      accuracy = 0.0;
    });
  }

  double calcAccuracy() {
    return StringSimilarity.compareTwoStrings(
        originalWord.substring(0, current), typedWord);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Typing Exercise",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 25, color: Colors.amberAccent),
          ),
        ),
        body: Builder(
          builder: (context) => Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Wrap(
                    runSpacing: 10.0,
                    spacing: 5.0,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.spaceEvenly,
                    children: displayOriginal(),
                  ),
                  PrgSpin(
                    progress: accuracy,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    typedWord,
                    style: TextStyle(fontSize: 24, color: Colors.cyan),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  DragTarget<String>(
                    onAcceptWithDetails: (details) {
                      print(details.data);
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Container(
                        height: 100,
                        width: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.tealAccent),
                        child: FaIcon(
                          FontAwesomeIcons.plus,
                          color: Colors.blue,
                          size: 50,
                        ),
                      );
                    },
                    onAccept: (data) {
                      setState(() {
                        // shuffledWord.remove(data);
                        matchStatus[current] = (data == originalWord[current]);
                        typedWord += data;
                        current++;
                        accuracy = calcAccuracy();
                      });

                      if (current == originalWord.length) {
                        onTypingCompleted();
                      }
                    },
                  ),
                  TweenAnimationBuilder<double>(
                      tween: Tween(begin: begin, end: end),
                      duration: Duration(milliseconds: 1000),
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(value, value),
                          child: child,
                        );
                      },
                      onEnd: () {
                        if (typedWord.length < 1) {
                          setState(() {
                            double temp = begin;
                            begin = end;
                            end = temp;
                          });
                        }
                      },
                      child: Image.asset(
                        "assets/pointer.png",
                        height: 50,
                        width: 50,
                      ))
                ],
              ),
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                spacing: 20.0,
                runSpacing: 10.0,
                children: [],
              ),
              Wrap(
                runSpacing: 10.0,
                spacing: 10.0,
                alignment: WrapAlignment.spaceEvenly,
                children: getBubbles(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AnimeButton(
                    width: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Reset",
                          style: TextStyle(fontSize: 18),
                        ),
                        Container(
                          height: 40,
                          width: 40,
                          padding: EdgeInsets.all(5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.red),
                          child: FaIcon(
                            Icons.refresh_rounded,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    onPressed: reset,
                  ),
                  AnimeButton(
                      width: 120,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Submit",
                            style: TextStyle(fontSize: 18),
                          ),
                          Container(
                            height: 40,
                            width: 40,
                            padding: EdgeInsets.all(5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.green),
                            child: FaIcon(
                              Icons.done,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                      onPressed: updateProgress)
                ],
              )
            ],
          )),
        ));
  }
}

class AlphaBubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Draggable(child: Container(), feedback: Container());
  }
}
