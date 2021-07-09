import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hello/auth/authentication.dart';
import 'package:hello/dyslexia/dyslexia_home.dart';
import 'package:hello/login.dart';
import 'package:hello/messaging/messaging_home.dart';
import 'package:hello/services/user_service.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({key}) : super(key: key);

  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  User currentUser = FirebaseAuth.instance.currentUser;

  void name(args) {}

  var timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 5000), (time) {
      FirebaseAuth.instance.currentUser.reload();
      if (FirebaseAuth.instance.currentUser.emailVerified)
        setState(() {
          emailVerified = true;
        });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  bool emailVerified = false;

  @override
  Widget build(BuildContext context) {
    if (emailVerified) {
      timer.cancel();
      UserService().getUsertype().then((isMessagingUser) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    (isMessagingUser ? MessagingHome() : DyslexiaHome())));
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify Email"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "A verification email has been sent to ${FirebaseAuth.instance.currentUser.email}. please open your mail and confirm",
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () async {
                AuthService().signOut().then((value) {
                  timer.cancel();
                  if (value == "success") {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  } else
                    print(" ${context.toString()} Error in logging out");
                });
              },
              child: Text("Logout",
                  style: TextStyle(
                    fontSize: 18,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
