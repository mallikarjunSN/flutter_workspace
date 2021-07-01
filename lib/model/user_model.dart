// import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class DyslexiaUser {
  String uid;
  String fullName;
  String email;

  DyslexiaUser({
    this.uid,
    this.fullName,
    this.email,
  });

  DyslexiaUser.fromJson(DocumentSnapshot doc) {
    Map data = doc.data();
    this.uid = doc.id;
    this.fullName = data["fullName"];
    this.email = data["email"];
  }

  // Map toJson(){
  //   return {
  //     ""
  //   }
  // }
  // DyslexiaUser.fromFirestore(DocumentSnapshot doc) {
  //   Map data = doc.data();
  //   this.uid = data["uid"];
  //   this.name = data["name"];
  //   this.email = data["email"];
  // }
}

class MessagingUser {
  String uid;
  String fullName;
  String email;
  List<String> contacts = [];
  List<String> chatIds = [];

  MessagingUser({
    this.uid,
    this.fullName,
    this.email,
    this.contacts,
    this.chatIds,
  });

  MessagingUser.fromJson(DocumentSnapshot doc) {
    Map data = doc.data();
    this.uid = doc.id.toString() ?? "";
    this.fullName = data["fullName"] ?? '';
    this.email = data["email"] ?? "";
    for (var item in data["contacts"]) {
      this.contacts.add(item.toString().trim());
    }
    for (var item in data["chatIds"]) {
      this.chatIds.add(item.toString().trim());
    }
  }
}

class UserType {
  static const String DYSLEXIA = "Dyslexia User";
  static const String MESSAGING = "Messaging User";
}
