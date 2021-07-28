import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hello/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  CollectionReference _mUserCollection;
  CollectionReference _dUserCollection;

  UserService() {
    _mUserCollection = FirebaseFirestore.instance.collection("messagingUsers");
    _dUserCollection = FirebaseFirestore.instance.collection("dyslexiaUsers");
  }

  Stream<DocumentSnapshot> getDyslexiUserName() {
    return _dUserCollection
        .doc(FirebaseAuth.instance.currentUser.uid)
        .snapshots();
  }

  Future<void> updateProfile(String uid, String fullName) async {
    await _mUserCollection.doc(uid).get().then((value) async {
      if (value.exists) {
        value.reference.update({"fullName": fullName});
      } else {
        await _dUserCollection.doc(uid).get().then((value) {
          value.reference.update({"fullName": fullName});
        });
      }
    });
  }

  Future<String> getUserName(String uid) async {
    Map<String, dynamic> data;
    String fullName;
    await _mUserCollection.doc(uid).get().then((value) async {
      if (value.exists) {
        data = value.data();
        fullName = data["fullName"];
      } else {
        await _dUserCollection.doc(uid).get().then((value) {
          data = value.data();
          fullName = data["fullName"];
        });
      }
    });
    return fullName;
  }

  Stream<DocumentSnapshot> getMessagingUser(String uid) {
    return _mUserCollection.doc(uid).snapshots();
  }

  Future<MessagingUser> getMessagingUserById(String uid) async {
    DocumentSnapshot doc = await _mUserCollection.doc(uid).get();
    return MessagingUser.fromJson(doc);
  }

  Future<MessagingUser> getMessagingUserByEmail(String email) async {
    QuerySnapshot qSnap =
        await _mUserCollection.where("email", isEqualTo: email).get();

    return MessagingUser.fromJson(qSnap.docs.first);
  }

  Stream<DocumentSnapshot> getMessagingUserAsStream(String uid) {
    return _mUserCollection.doc(uid).snapshots();
  }

  Future<bool> getUserTypeByEmail(String email) {
    return _dUserCollection.where("email", isEqualTo: email).get().then((res1) {
      if (res1.docs.length == 0)
        return true;
      else
        return false;
    });
  }

  Future<void> updateContactsChatIds(
    MessagingUser mUser,
    String chatId,
    String email,
  ) async {
    await _mUserCollection.doc(mUser.uid).update({
      "contacts": FieldValue.arrayUnion(
        [email],
      ),
      "chatIds": FieldValue.arrayUnion([chatId.trim()])
    }).then((value) {
      print("user1 updated");
    });

    await this.getMessagingUserByEmail(email).then((addedUser) {
      _mUserCollection.doc(addedUser.uid).update({
        "contacts": FieldValue.arrayUnion(
          [mUser.email],
        ),
        "chatIds": FieldValue.arrayUnion([chatId.trim()])
      }).then((value) {
        print("user2 updated");

        this.getMessagingUserById(FirebaseAuth.instance.currentUser.uid);
      });
    });
  }

  Future<void> saveUsertype(bool isMessagingUser) async {
    print("saving usertype $isMessagingUser");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isMessagingUser", isMessagingUser);
  }

  Future<bool> getUsertype() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isMessagingUser");
  }
}
