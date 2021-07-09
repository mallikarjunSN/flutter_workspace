import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hello/custom_widgets/my_drawer.dart';
import 'package:hello/dyslexia/exercises_home.dart';
import 'package:hello/dyslexia/my_btm_bar.dart';
import 'package:hello/dyslexia/progress_ui.dart';
import 'package:hello/model/r_words.dart';
import 'package:hello/model/words_model.dart';
import 'package:hello/services/db_service.dart';
import 'package:hello/services/other_services.dart';

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
    Progress(),
  ];

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
              child: Image.network(
                "https://cdn1-www.superherohype.com/assets/uploads/2013/11/batmane3-1.jpg",
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
        body: Center(
          child: screens.elementAt(currentIdx),
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

  List<Map<String, String>> rw = Raw.words;
  Future<void> upload() async {
    for (var w in rw) {
      await OtherServices().uploadReadingWord(w).then((value) {
        setState(() {
          count++;
        });
      });
    }
    print("completely done");
  }

  Future<void> uploadSingle() async {
    await OtherServices().uploadReadingWord(rw[0]).then((value) {
      print("success");
    });
  }

  void getWords() async {
    List<ReadingWord> rws =
        await DatabaseService().getReadingWordsByLevel("medium");

    print(rws[0].level);
  }

  void delete() {
    DatabaseService().deleteReadingWords();
  }

  int count = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "fgkldfhkgfgkhdfkghdfkghdfkjghdfkjghdfkjghdfjkghjdkfghjkdfhgkjdhf",
            textAlign: TextAlign.center,
          ),
          ElevatedButton(onPressed: getWords, child: Text("get rWords")),
          ElevatedButton(onPressed: delete, child: Text("delete rWords")),
        ],
      ),
    );
  }
}