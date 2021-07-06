import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  User currentUser;
  Future<String> signIn(String email, String password) async {
    try {
      UserCredential userCred = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      currentUser = userCred.user;
      return "success";
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<String> signUp(String email, String password) async {
    try {
      UserCredential userCred = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      currentUser = userCred.user;
      return "success";
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<String> signOut() async {
    try {
      auth.signOut();
      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
