import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DyslexiaHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DyslexiaHomeState();
  }
}

class DyslexiaHomeState extends State<DyslexiaHome> {
  int selectedIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget menu = new Container(
    child: Column(
      children: [
        Card(
          // shape,
          elevation: 20,
          child: Center(
            child: Text(
              "Reading assessments",
              style: TextStyle(fontSize: 100),
            ),
          ),
        ),
        Card(
          elevation: 20,
          child: Center(
            child: Text("Typing assessments"),
          ),
        )
      ],
    ),
  );

  List<Widget> _children = [
    Container(
      color: Colors.purpleAccent,
      width: double.infinity,
      height: 650,
      child: Center(
          child: Text(
        "Hello",
        style: TextStyle(color: Colors.white),
      )),
    ),
    Container(
        color: Colors.amber,
        width: double.infinity,
        height: 650,
        child: Center(
          child: Container(
            child: Column(
              children: [
                Card(
                  // shape,
                  elevation: 20,
                  child: Center(
                    child: Text(
                      "Reading assessments",
                      style: TextStyle(fontSize: 50),
                    ),
                  ),
                ),
                Card(
                  elevation: 20,
                  child: Center(
                    child: Text("Typing assessments"),
                  ),
                )
              ],
            ),
          ),
        )),
    Container(
      color: Colors.indigo,
      width: double.infinity,
      height: 650,
      child: Center(
          child: Text(
        "Account settings",
        style: TextStyle(color: Colors.white),
      )),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SafeArea(
          child: Wrap(
        children: [
          Center(
            child: _children[selectedIndex],
          )
        ],
      )),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              title: Text("Home"), icon: Icon(FontAwesomeIcons.home)),
          BottomNavigationBarItem(
              title: Text("Assessments"), icon: Icon(FontAwesomeIcons.cogs)),
          BottomNavigationBarItem(
              title: Text("account"), icon: Icon(FontAwesomeIcons.userCircle))
        ],
        onTap: onTabTapped,
        iconSize: 24.0,
        selectedItemColor: Colors.white,
        backgroundColor: Colors.blue,
      ),
    );
  }
}
