import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello/assessments.dart';
import 'package:hello/auth.dart';
import 'package:hello/login.dart';

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

  void onTapListener(int index) async {
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

  void getWFD() {
    _firebaseDatabase.once().then((snapshot) => setState(() {
          if (snapshot.value != null) {
            wordForTheDay = snapshot.value["wfd"];
            print(snapshot.value);
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
              // title: Text(
              //   "__",
              //   style: TextStyle(
              //       fontWeight: FontWeight.bold,
              //       color: Colors.white,
              //       fontSize: 30.0),
              // ),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("word for the day"),
                                (wordForTheDay != null
                                    ? Text(
                                        wordForTheDay,
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : CircularProgressIndicator()),
                                RaisedButton(
                                  child: Text("get"),
                                  onPressed: getWFD,
                                )
                              ],
                            )
                          : Text(items.elementAt(index))),
                      // color: Colors.cyan[((index + 1) * 100) % 1000 + 100],
                    )),
                onTap: () => onTapListener(index),
              );
            }))
          ],
        ),
      ),
    );
  }
}
