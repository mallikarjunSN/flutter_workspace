import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello/home.dart';
import 'package:hello/login.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  User currentUser;
  Future signIn(String email, String password, BuildContext context) async {
    try {
      UserCredential user = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      print("success bro");
      // auth.cre
      print("user got : ${user.user}");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => DyslexiaHome()));

      currentUser = user.user;
    } catch (e) {
      print("Has some error ${e.toString()}");
    }
  }

  Future<void> signOut(BuildContext context) {
    try {
      auth.signOut();
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    } catch (e) {
      return null;
    }

    return null;
  }
}
