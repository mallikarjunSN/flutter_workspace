import 'package:flutter/material.dart';
import 'package:hello/home.dart';
// import 'package:hello/input.dart';
// import 'package:hello/page_four.dart';
// import 'package:hello/temp.dart';
// import 'package:hello/page_four.dart';
// import 'package:hello/tic_tac.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  // MyAppState createState() => MyAppState();
  // bool theme = false;
  // ThemeData theme = ThemeData.light();
  // Set<ThemeData> themes = {ThemeData.light(), ThemeData.dark()};
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DyslexiaHome(),
      theme: ThemeData.light(),
    );
  }
}

class MyHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyHomeState();
  }
}

class MyHomeState extends State<MyHome> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter App : App Bar"),
      ),
      body: Center(
          child: Column(
        children: [
          Text(
            'What is favourite IPL team?❤',
            style: TextStyle(fontSize: 30),
          ),
          Column(
            children: [
              Column(
                children: [
                  RaisedButton(
                      color: Color.fromARGB(255, 255, 0, 0),
                      child: Text(
                        "RCB",
                        style: TextStyle(
                            fontSize: 55,
                            // fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 255, 0)),
                      ),
                      onPressed: () {
                        // response = "ESCN";
                      }),
                ],
              ),
            ],
          ),
          Text("response"),
          CircularProgressIndicator(),
          /* ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            child: Image.asset("assets/god_ganesha.jpg"),
            // child: Container(
            //   width: 200,
            //   height: 200,
            //   color: Colors.cyan,
            // )
          ), */
          RaisedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SecondPage()));
            },
            child: Text("Goto Next page"),
          ),
        ],
      )),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second page"),
      ),
      body: Center(
          child: Column(
        children: [
          RaisedButton(
              color: Colors.blue,
              child: Text("Go Back"),
              onPressed: () {
                Navigator.pop(context);
              }),
          RaisedButton(
              color: Colors.blue,
              child: Text("Third Page"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ThirdPage()));
              }),
        ],
      )),
    );
  }
}

class ThirdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Third Page"),
      ),
      body: Center(
        child: FloatingActionButton(
            child: Text(
              "Go back",
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              textScaleFactor: 1.2,
            ),
            onPressed: () => Navigator.pop(context)),
      ),
      bottomNavigationBar:
          BottomNavigationBar(items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
        BottomNavigationBarItem(
            icon: Icon(Icons.account_balance), title: Text("Account")),
      ]),
    );
  }
}
