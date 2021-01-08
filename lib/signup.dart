import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello/custom_dialog.dart';
// import 'package:hello/sp_sr.dart';
// import 'package:hello/sp_sr.dart';

class Signup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignupState();
  }
}

class SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Signup"),
          centerTitle: true,
          actions: [],
        ),
        body: Center(
          child: RaisedButton(
            child: Text("CD"),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CustomDialog()));
            },
          ),
        ));
  }
}
