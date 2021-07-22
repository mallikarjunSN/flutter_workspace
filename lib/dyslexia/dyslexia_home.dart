import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hello/about.dart';
import 'package:hello/custom_widgets/anime_button.dart';
import 'package:hello/custom_widgets/cool_color.dart';
import 'package:hello/custom_widgets/my_drawer.dart';
import 'package:hello/dyslexia/exercises_home.dart';
import 'package:hello/dyslexia/my_btm_bar.dart';
import 'package:hello/dyslexia/progress_ui.dart';
import 'package:hello/dyslexia/reading_page.dart';
import 'package:hello/dyslexia/typing.dart';
import 'package:hello/model/r_words.dart';
import 'package:hello/model/user_model.dart';
import 'package:hello/model/words_model.dart';
import 'package:hello/services/db_service.dart';
import 'package:hello/services/other_services.dart';
import 'package:hello/services/string_service.dart';
import 'package:hello/services/user_service.dart';

class DyslexiaHome extends StatefulWidget {
  const DyslexiaHome({key}) : super(key: key);

  @override
  _DyslexiaHomeState createState() => _DyslexiaHomeState();
}

class _DyslexiaHomeState extends State<DyslexiaHome> {
  static int currentIdx = 0;

  List<Widget> screens = [
    Home(),
    ExercisesHome(),
    ProgressUI(),
  ];

  int count = 0;

  @override
  Future<void> dispose() async {
    await DatabaseService().closeDatabase();
    super.dispose();
  }

  void initState() {
    super.initState();
    DatabaseService().intializeDatabase();
  }

  double currentSize = 30;

  double twoPi = 2 * pi;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            elevation: 30,
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                "assets/user.png",
                fit: BoxFit.cover,
                height: 100,
                width: 100,
              ),
            ),
          ),
        ),
        drawer: MyDrawer(
          current: context.widget.toString(),
        ),
        body: FutureBuilder<void>(
          future: DatabaseService().populateDB(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Center(
                child: screens.elementAt(currentIdx),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        bottomNavigationBar: MyBottomBar(
            currentIdx: currentIdx,
            onTap: (value) {
              setState(() {
                currentIdx = value;
              });
            }));
  }
}

class Home extends StatefulWidget {
  const Home({key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic> word = {
    "word": "sdfgsd",
    "syllables": "jsdfkjsd",
    "syllablesPron": "sdfhdf",
    "lastAccuracy": 45.0,
    "lastAttemptOn": DateTime.now().toIso8601String()
  };

  String str;

  int count = 0;

  List<Map<String, String>> tw = Raw.typingWords;
  Future<void> upload() async {
    for (var w in tw) {
      await OtherServices().uploadTypingWord(w).then((value) {
        setState(() {
          count++;
        });
      });
    }
    print("completely done");
  }

  Future<void> uploadSingle() async {
    await OtherServices().uploadTypingWord(tw[0]).then((value) {
      print("success");
    });
  }

  void delete() {
    // DatabaseService().deleteReadingWords();
    DatabaseService().deleteTypingWords();
  }

  Widget getUtButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          "Hello",
          textAlign: TextAlign.center,
        ),
        ElevatedButton(onPressed: upload, child: Text("Upload all")),
        ElevatedButton(onPressed: uploadSingle, child: Text("Upload single")),
        // ElevatedButton(onPressed: delete, child: Text("Delete rwords")),
        ElevatedButton(onPressed: delete, child: Text("Delete twords")),
        ElevatedButton(
          onPressed: () async {
            await DatabaseService().deleteDB();
          },
          child: Text("delete DB"),
        ),
      ],
    );
  }

  double height, width;

  void _howAppHelps() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("How our App can Help??"),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Our app provides learning exercies which assist people with dyslexia by\n",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    """1. Reading Exercises : giving a demo of how to pronounces the word and allow dyslexic user to practice pronunciation.
                     \n2. Typing Exercises  : help them recogize individual letters and their sounds.
                     \n3. Track progress : track learning progress based on number of words attempted and accuracy of each attempt.
                    """,
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Close"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Center(
            child: StreamBuilder<DocumentSnapshot>(
              stream: UserService().getDyslexiUserName(),
              builder: (context, snapshot) {
                DyslexiaUser dUser;
                if (snapshot.hasData) {
                  dUser = DyslexiaUser.fromJson(snapshot.data);
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Welcome",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "${StringService().capitalize(dUser.fullName)}",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: CoolColor.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: height * 0.2,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.amberAccent,
                            borderRadius: BorderRadius.circular(10)),
                        child: StreamBuilder<DocumentSnapshot>(
                          stream: OtherServices().getWfdAsStream(),
                          builder: (context, snapshot) {
                            ReadingWord rw;
                            TypingWord tw;
                            if (snapshot.hasData) {
                              rw = ReadingWord.fromJsom(snapshot.data.data());
                              tw = TypingWord.fromJsom(snapshot.data.data());
                              return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Word for the day",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${tw.word}",
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      AnimeButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ReadingPage(
                                                            readingWord: rw)));
                                          },
                                          child: Image.asset(
                                            "assets/reading.png",
                                            height: 40,
                                            width: 40,
                                          )),
                                      AnimeButton(
                                          backgroundColor: Colors.cyan,
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        TypingPage(
                                                          typingWord: tw,
                                                        )));
                                          },
                                          child: Image.asset(
                                            "assets/typing.png",
                                            height: 40,
                                            width: 40,
                                          ))
                                    ],
                                  )
                                ],
                              );
                            } else
                              return CircularProgressIndicator();
                          },
                        ),
                      ),
                      Divider(
                        thickness: 1.5,
                      ),
                      Container(
                        height: height * 0.25,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.lightBlueAccent,
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "What is dyslexia?",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Divider(
                              indent: width * 0.25,
                              endIndent: width * 0.25,
                              color: Colors.black,
                            ),
                            Text(
                              "Dyslexia is a learning disorder that involves difficulty reading due to problems identifying speech sounds and learning "
                              " how they relate to letters and words",
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AboutPage()));
                                },
                                child: Text(
                                  "know more",
                                  textAlign: TextAlign.center,
                                )),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1.5,
                      ),
                      Container(
                        height: height * 0.25,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "How our App can help?",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Divider(
                              indent: width * 0.25,
                              endIndent: width * 0.25,
                              color: Colors.black,
                            ),
                            Text(
                              "Our App provides Reading and Typing exercises, which can help people with dyslexia to practice reading and recognizing the letters and words.",
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            ElevatedButton(
                              onPressed: _howAppHelps,
                              child: Text("How our app can help..?"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else
                  return CircularProgressIndicator();
              },
            ),
          )),
    );
  }
}
