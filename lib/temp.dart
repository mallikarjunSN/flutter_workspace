import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello/assessments.dart';
import 'package:hello/auth.dart';
import 'package:hello/login.dart';
import 'package:hello/progress.dart';

class Temp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TempState();
  }
}

AuthService _authService = AuthService();

class TempState extends State<Temp> {
  List<String> items = [
    "word for the day",
    "Reading assessments",
    "Typing assessments",
    "Statistics",
    "logout"
  ];

  void onTapListener(int index, BuildContext context) async {
    switch (index) {
      case 0:
        print(items.elementAt(index));
        break;
      case 1:
        // print(items.elementAt(index));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Assessment(),
                settings: RouteSettings(arguments: 1)));
        break;
      case 2:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Assessment(),
                settings: RouteSettings(arguments: 2)));
        break;
      case 3:
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "Statistics",
              textAlign: TextAlign.center,
            ),
            content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                      "Total Words attempted - ${UserProgress.totalWordsAttempted}"),
                  SizedBox(
                    height: 20,
                  ),
                  // Text(UserProgress.totalWordsAttempted),
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Center(
                          child: Container(
                            height: 140,
                            width: 140,
                            decoration: BoxDecoration(
                                color: Colors.yellow[800],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(70))),
                            child: CircularProgressIndicator(
                              value: UserProgress.accuracy,
                              strokeWidth: 15,
                              backgroundColor: Colors.grey.shade400,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            "Accuracy\n ${(UserProgress.accuracy * 100).toStringAsPrecision(3)} %",
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
                ]),
            actions: [
              RaisedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              )
            ],
          ),
        );
        print(items.elementAt(index));
        break;
      case 4:
        await _authService.signOut().then((value) => (value == "success"
            ? Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Login()))
            : print("some error")));
        print(items.elementAt(index));
        break;
    }
  }

  final _firebaseDatabase = FirebaseDatabase.instance.reference();

  String wordForTheDay;
  String fullName = "";

  void getWFD() async {
    await _firebaseDatabase.once().then((snapshot) => setState(() {
          if (snapshot.value != null) {
            wordForTheDay = snapshot.value["wfd"];
            fullName = snapshot.value[FirebaseAuth.instance.currentUser.uid]
                ["fullname"];
            print(snapshot.value[FirebaseAuth.instance.currentUser.uid]);
          } else {
            wordForTheDay = "Unable to load word for the day";
          }
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              title: Text(
                "welcome\n$fullName",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 25.0),
              ),
              expandedHeight: 180.0,
              flexibleSpace: FlexibleSpaceBar(
                background: FittedBox(
                    fit: BoxFit.cover, child: Image.asset("assets/brain.jpg")),
              ),
            ),
            SliverList(delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              if (index > items.length - 1) return null;
              return GestureDetector(
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.cyan[((index + 1) * 100) % 1000 + 100],
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    height: (index == 0 ? 200 : 120),
                    width: double.infinity,
                    child: Center(
                      child: (index == 0
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("word for the day"),
                                (wordForTheDay != null
                                    ? Text(
                                        "\" $wordForTheDay \"",
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )
                                    : SizedBox()),
                                RaisedButton(
                                  child: Text("get"),
                                  onPressed: getWFD,
                                )
                              ],
                            )
                          : Text(
                              items.elementAt(index),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 25.0),
                            )),
                    )),
                onTap: () => onTapListener(index, context),
              );
            }))
          ],
        ),
      ),
    );
  }
}
