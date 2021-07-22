import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<void> unBlock(String chatId) async {
    await _chatsReference.doc(chatId).update({
      "blocked": false,
      "blockerUid": null,
    });
  }

  Future<void> block(String chatId) async {
    await _chatsReference.doc(chatId).update({
      "blocked": true,
      "blockerUid": FirebaseAuth.instance.currentUser.uid,
    });
  }

  Stream<DocumentSnapshot> getChatDetailsAsStream(String chatId) {
    return _chatsReference.doc(chatId).snapshots();
  }

  Future<void> markAsRead(String chatId) async {
    await _chatsReference.doc(chatId).update({
      "newMessagesCount": 0,
      "lastAuthorUid": FirebaseAuth.instance.currentUser.uid,
    });
  }

  Future<String> addNewChat(List<String> partcipantsEmail) async {
    String chatId = await _chatsReference.add({
      "blocked": false,
      "participantsEmail": partcipantsEmail,
      "lastMessage": null,
      "lastMessageOn": null,
      "newMessagesCount": 0,
      "blockerUid": null,
      "lastAuthorUid": null,
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
    }).then((value) {
      _chatsReference.doc(chatId).update({
        "newMessagesCount": FieldValue.increment(1),
        "lastMessage": message.content,
        "lastMessageOn": message.time,
        "lastAuthorUid": message.authorUid,
      });
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
