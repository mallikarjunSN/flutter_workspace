import 'package:cloud_firestore/cloud_firestore.dart';

class ChatDetails {
  String chatId;
  String lastMessage;
  Timestamp lastMessageOn;
  bool blocked;
  int newMessagesCount;
  String blockerUid;
  String lastAuthorUid;
  List<String> participantsEmail = [];

  ChatDetails({
    this.chatId,
    this.lastMessage,
    this.lastMessageOn,
    this.participantsEmail,
    this.blocked,
    this.blockerUid,
    this.lastAuthorUid,
    this.newMessagesCount,
  });

  ChatDetails.fromJson(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    this.chatId = doc.id;
    this.lastMessage = data["lastMessage"];
    this.lastMessageOn = data["lastMessageOn"];
    for (var p in data["participantsEmail"]) {
      this.participantsEmail.add(p.toString());
    }
    this.newMessagesCount = data["newMessagesCount"];
    this.blocked = data["blocked"];
    this.lastAuthorUid = data["lastAuthorUid"];
    this.blockerUid = data["blockerUid"];
  }
}
