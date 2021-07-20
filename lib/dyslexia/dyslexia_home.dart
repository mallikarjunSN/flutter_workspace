import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hello/custom_widgets/my_drawer.dart';
import 'package:hello/dyslexia/exercises_home.dart';
import 'package:hello/dyslexia/my_btm_bar.dart';
import 'package:hello/dyslexia/progress_ui.dart';
import 'package:hello/model/r_words.dart';
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
          fullName: "Rajesh",
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
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
      ),
    );
  }
}
