import 'package:cloud_firestore/cloud_firestore.dart';

class ChatDetails {
  String chatId;
  String lastMessage;
  Timestamp lastMessageOn;
  bool blocked;
  List<String> participantsEmail = [];

  ChatDetails({
    this.chatId,
    this.lastMessage,
    this.lastMessageOn,
    this.participantsEmail,
    this.blocked,
  });

  ChatDetails.fromJson(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    this.chatId = doc.id;
    this.lastMessage = data["lastMessage"];
    this.lastMessageOn = data["lastMessageOn"];
    for (var p in data["participantsEmail"]) {
      this.participantsEmail.add(p.toString());
    }
    this.blocked = data["blocked"];
  }
}
