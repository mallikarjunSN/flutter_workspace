import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hello/model/user_model.dart';
import 'package:hello/services/user_service.dart';

class MessagingUserManager extends ChangeNotifier {
  MessagingUser _messagingUser;
  MessagingUserManager() {
    init();
  }

  void init() async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    _messagingUser = await UserService().getMessagingUserById(uid);
    notifyListeners();
  }

  MessagingUser get messagingUser => this._messagingUser;
}
