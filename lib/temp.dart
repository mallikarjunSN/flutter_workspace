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
            context, MaterialPageRoute(builder: (context) => Assessment()));
        break;
      case 2:
        print(items.elementAt(index));
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

  // String data = jsondata.beginner.1[1];

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
                  height: 100,
                  width: double.infinity,
                  child: Center(child: Text(items.elementAt(index))),
                  // color: Colors.cyan[((index + 1) * 100) % 1000 + 100],
                ),
                onTap: () => onTapListener(index),
              );
            }))
          ],
        ),
      ),
    );
  }
}
