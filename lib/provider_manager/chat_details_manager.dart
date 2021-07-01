import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ChatDetailsManager extends ChangeNotifier {
  Stream<QuerySnapshot> chatDetailsStream;

  // void addNewChatDetails(ChatDetails cd) {
  //   this._allChatDetails.add(cd);
  //   notifyListeners();
  // }

  void initChatDetails() {
    // _allChatDetails = cd;
  }

  Stream<QuerySnapshot> get getAllChatDetailsStream => this.chatDetailsStream;
}
