import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hello/model/user_model.dart';

class UserService {
  CollectionReference mUserCollection;
  CollectionReference dUserCollection;

  UserService() {
    mUserCollection = FirebaseFirestore.instance.collection("messagingUsers");
    dUserCollection = FirebaseFirestore.instance.collection("dyslexiaUsers");
  }

  Future<MessagingUser> getMessagingUserById(String uid) async {
    DocumentSnapshot doc = await mUserCollection.doc(uid).get();
    return MessagingUser.fromJson(doc);
  }

  Future<MessagingUser> getMessagingUserByEmail(String email) async {
    QuerySnapshot qSnap =
        await mUserCollection.where("email", isEqualTo: email).get();

    return MessagingUser.fromJson(qSnap.docs.first);
  }

  Future<void> updateContactsChatIds(
    MessagingUser mUser,
    String chatId,
    String email,
  ) async {
    await mUserCollection.doc(mUser.uid).update({
      "contacts": FieldValue.arrayUnion(
        [email],
      ),
      "chatIds": FieldValue.arrayUnion([chatId.trim()])
    }).then((value) {
      print("user1 updated");
    });

    await this.getMessagingUserByEmail(email).then((addedUser) {
      mUserCollection.doc(addedUser.uid).update({
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
}
