import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:hello/custom_dialog.dart';
import 'package:hello/sp_sr.dart';

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
                  MaterialPageRoute(builder: (context) => VoiceHome()));
            },
          ),
        ));
      appBar: AppBar(
        title: Text("Signup"),
        centerTitle: true,
        actions: [],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Welcome to signup Page"),
            RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/tictac',
                      arguments: "Hello message");
                },
                child: Text("goto Tic-Tac-Toe")),
          ],
        ),
      ),
    );
  }
}
