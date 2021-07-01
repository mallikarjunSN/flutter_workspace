import 'package:cloud_firestore/cloud_firestore.dart';

class ChatDetailsService {
  CollectionReference chatsReference;

  ChatDetailsService() {
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
}
