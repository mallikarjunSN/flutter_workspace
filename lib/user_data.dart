// import 'package:firebase_auth/firebase_auth.dart';

class Userdata {
  String uid;
  String name;

  Userdata(this.uid, this.name);

  Userdata.fromJson(Map<String, dynamic> json) {
    uid = json["uid"];
    name = json["name"];
  }
}
