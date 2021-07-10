// import 'dart:html';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hello/custom_widgets/cool_color.dart';
import 'package:hello/services/db_service.dart';
import 'package:hello/services/string_service.dart';

class Data {
  bool reading;
  String level;
  Data({this.reading, this.level});
}

class WordList extends StatefulWidget {
  const WordList({key}) : super(key: key);

  @override
  _WordListState createState() => _WordListState();
}

class _WordListState extends State<WordList> {
  /// defines the name of user
  String name;

  Key nameKey = Key("name");

  @override
  void initState() {
    super.initState();
  }

  final Map levelIcon = {
    "Easy": FontAwesomeIcons.baby,
    "Medium": FontAwesomeIcons.userGraduate,
    "Hard": FontAwesomeIcons.userAstronaut
  };

  final List<String> excWords = [
    "Hello",
    "world",
    "is",
    "really",
    "cool",
    "Hello",
    "world",
    "is",
    "really",
    "cool",
    "Hello",
    "world",
    "is",
    "really",
    "cool",
    "Hello",
    "world",
    "is",
    "really",
    "cool"
  ];

  final Map<String, String> levelImages = {
    "reading_easy": "assets/icons/easy.png",
    "reading_medium": "assets/icons/medium.png",
    "reading_hard": "assets/icons/hard.png",
    "typing_easy": "assets/icons/1star.png",
    "typing_medium": "assets/icons/2star.png",
    "typing_hard": "assets/icons/3star.png",
  };
  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments;
    final String level = args["level"];
    final String type = args["type"];

    String table = (type == "reading" ? "ReadingWords" : "typingWords");

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            actions: [IconButton(icon: Icon(Icons.settings), onPressed: () {})],
            collapsedHeight: 210,
            pinned: true,
            title: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${StringService().capitalize(type)} Exercises\nLevel : $level",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            centerTitle: true,
            flexibleSpace: Hero(
              tag: "${type}_$level",
              child: Container(
                padding: EdgeInsets.only(top: 25),
                decoration: BoxDecoration(
                  gradient: RadialGradient(colors: [
                    CoolColor().getColor(0xE684AE),
                    CoolColor().getColor(0x753A88),
                  ], radius: 0.7),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Image.asset(
                    levelImages["${type}_$level"],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          StreamBuilder(
            stream: DatabaseService().getWordsByLevelAsStream(table, level),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Map<String, dynamic>> data = snapshot.data;
                return SliverAnimatedList(
                  initialItemCount: data.length,
                  itemBuilder: (context, index, animation) {
                    String word = data[index]["word"];
                    double lac = data[index]["lastAccuracy"];
                    return Center(
                      child: TweenAnimationBuilder<double>(
                        duration: Duration(milliseconds: 1000),
                        child: SizedBox(
                          height: 120,
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: Card(
                            elevation: 20,
                            margin: EdgeInsets.only(top: 15),
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    word,
                                    style: TextStyle(
                                        color: Colors.indigo,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  CircularProgressIndicator(
                                    value: lac,
                                    backgroundColor:
                                        Colors.blue.withOpacity(0.1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        tween: Tween(begin: 0, end: 1),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            origin: Offset(0, 0),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                );
              } else {
                return SliverList(
                    delegate: SliverChildListDelegate.fixed([
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    padding: EdgeInsets.all(25),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ]));
              }
            },
          )
        ],
      ),
    );
  }
}

class Lliisstt extends StatelessWidget {
  const Lliisstt({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TweenAnimationBuilder<double>(
        duration: Duration(milliseconds: 1000),
        child: SizedBox(
          height: 100,
          width: 320,
          child: Card(
            elevation: 20,
            margin: EdgeInsets.only(bottom: 20),
            child: Center(
              child: Text(
                "exc_words.elementAt(index)",
              ),
            ),
          ),
        ),
        tween: Tween(begin: 0, end: 1),
        curve: Curves.elasticOut,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            origin: Offset(0, 0),
            child: child,
          );
        },
      ),
    );
  }
}

/*
Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: TextField(
                key: nameKey,
                // decoration: InputDecoration(/),
                scrollPadding: EdgeInsets.all(10),
                decoration: InputDecoration(),
                style: TextStyle(fontSize: 30, color: Colors.black),

                textAlign: TextAlign.center,
                onSubmitted: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                saveName(name);
              },
              child: Text("SUBMIT"),
            ),
            ElevatedButton(
              onPressed: () {
                resetName();
              },
              child: Text("RESET"),
            )
          ],
        )
*/
