import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hello/auth.dart';
import 'package:hello/login.dart';

class DyslexiaHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DyslexiaHomeState();
  }
}

class DyslexiaHomeState extends State<DyslexiaHome> {
  final _databaseRef = FirebaseDatabase.instance.reference();

  static AuthService _authService = AuthService();

  User currentUser = FirebaseAuth.instance.currentUser;

  static List<String> ops = ["read", "write", "update", "delete"];

  Map<String, dynamic> realData;

  void read() {
    _databaseRef.once().then((snapshot) {
      if (snapshot.value != null) {
        print(snapshot.value);
        setState(() {
          name = snapshot.value[currentUser.uid]["name"];
        });
      }
    });
  }

  void write() {
    _databaseRef.child(currentUser.uid).set({"name": "Current user"});
  }

  void update() {
    _databaseRef.child(currentUser.uid).update({"name": "New Updated name"});
  }

  void delete() {
    _databaseRef.child(currentUser.uid).remove();
  }

  String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SafeArea(
          child: Wrap(
        children: [
          Center(
            child: Container(
              // color: Colors.purpleAccent,
              width: double.infinity,
              height: 650,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Data from database",
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text((name == null ? "no data available" : name)),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RaisedButton(child: Text("Read"), onPressed: read),
                        RaisedButton(child: Text("write"), onPressed: write),
                        RaisedButton(child: Text("update"), onPressed: update),
                        RaisedButton(child: Text("delete"), onPressed: delete),
                        RaisedButton(
                            child: Text("logout"),
                            onPressed: () async {
                              await _authService
                                  .signOut()
                                  .then((value) => (value == "success"
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Login(),
                                          ))
                                      : print("error logging out")));
                            }),
                      ]),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
