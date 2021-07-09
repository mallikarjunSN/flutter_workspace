import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hello/messaging/messages_ui.dart';

class ChatService {
  CollectionReference _chatsReference;

  ChatService() {
    _chatsReference = FirebaseFirestore.instance.collection("chats");
  }

  Stream<QuerySnapshot> getAllChatDetails(List<String> chatIds) {
    return _chatsReference
        .where(FieldPath.documentId, whereIn: chatIds)
        .snapshots();
  }

  Future<String> addNewChat(List<String> partcipantsEmail) async {
    String chatId = await _chatsReference.add({
      "blocked": false,
      "participantsEmail": partcipantsEmail,
      "lastMessage": null,
      "lastMessageOn": null
    }).then((value) => value.id);

    return chatId;
  }

  Stream<QuerySnapshot> getMessagesStream(String chatId) {
    return _chatsReference
        .doc(chatId)
        .collection("messages")
        .orderBy("time", descending: true)
        .snapshots();
  }

  Future<void> addMessage(String chatId, Message message) {
    return _chatsReference.doc(chatId).collection("messages").add({
      "authorUid": message.authorUid,
      "content": message.content,
      "time": message.time,
      "status": message.status,
    });
  }

  Future<QuerySnapshot> getRecentMessage(String chatId) {
    return _chatsReference
        .doc(chatId)
        .collection("messages")
        .limit(1)
        .orderBy("time", descending: true)
        .get()
        .then((value) => value);
  }
}
