import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hello/messaging/messages_ui.dart';

class ChatService {
  CollectionReference chatsReference;

  ChatService() {
    chatsReference = FirebaseFirestore.instance.collection("chats");
  }

  Stream<QuerySnapshot> getAllChatDetails(List<String> chatIds) {
    return chatsReference
        .where(FieldPath.documentId, whereIn: chatIds)
        .snapshots();
  }

  Future<String> addNewChat(List<String> partcipantsEmail) async {
    String chatId = await chatsReference.add({
      "blocked": false,
      "participantsEmail": partcipantsEmail,
      "lastMessage": null,
      "lastMessageOn": null
    }).then((value) => value.id);

    return chatId;
  }

  Stream<QuerySnapshot> getMessagesStream(String chatId) {
    return chatsReference
        .doc(chatId)
        .collection("messages")
        .orderBy("time", descending: true)
        .snapshots();
  }

  Future<void> addMessage(String chatId, Message message) {
    return chatsReference.doc(chatId).collection("messages").add({
      "authorUid": message.authorUid,
      "content": message.content,
      "time": message.time,
      "status": message.status,
    });
  }
}
