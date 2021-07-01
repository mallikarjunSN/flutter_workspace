import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessagesUI extends StatefulWidget {
  const MessagesUI({key}) : super(key: key);

  @override
  _MessagesUIState createState() => _MessagesUIState();
}

class Message {
  String authorUid;
  String content;
  Timestamp time;
  int status;

  Message({
    this.authorUid,
    this.content,
    this.time,
    this.status,
  });

  Message.fromJsom(Map<String, dynamic> data) {
    this.authorUid = data["authorUid"];
    this.content = data["content"];
    this.status = data["status"];
    this.time = data["time"];
  }
}

class _MessagesUIState extends State<MessagesUI> {
  String message = '';
  List<Message> messages = [];

  var textController = TextEditingController();

  final Stream<QuerySnapshot> messagesStream = FirebaseFirestore.instance
      .collection("chats")
      .where(FieldPath.documentId, isEqualTo: "qaPorAqazkCTuKEjvoVo")
      .snapshots();

  final CollectionReference messagesReference = FirebaseFirestore.instance
      .collection("chats")
      .doc("qaPorAqazkCTuKEjvoVo")
      .collection("messages");

  @override
  void initState() {
    super.initState();
  }

  void sendMessage() {
    messagesReference.add({
      "authorId": FirebaseAuth.instance.currentUser.uid,
      "content": message,
      "status": 1,
      "time": Timestamp.now()
    });
  }

  int linesCount = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [Text("Chat 'N'"), Icon(Icons.chat)],
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 60,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.94,
                width: 360,
                child: StreamBuilder<QuerySnapshot>(
                  stream: messagesStream,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.docs.length == 0) {
                        return Text("No Messages, start now..!!");
                      } else {
                        return ListView(
                          children:
                              snapshot.data.docs.map((DocumentSnapshot doc) {
                            // var data = doc.data() as Map<String, dynamic>;
                            // print(data);
                            ListTile(
                              title: Text("content"),
                            );
                          }).toList(),
                        );
                      }
                    }
                    if (snapshot.hasError) {
                      return Text("error");
                    } else
                      return Text(snapshot.hasData.toString());
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 4,
              child: SizedBox(
                width: 360,
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: linesCount + 5,
                  minLines: 1,
                  controller: textController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.emoji_emotions,
                      color: Colors.amber,
                    ),
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.all(5),
                    hintText: "Type your message here....",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    suffixIcon: IconButton(
                      icon: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.blue),
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          )),
                      onPressed: () {
                        if (message.isNotEmpty) {
                          sendMessage();
                          setState(() {
                            message = '';
                            textController.clear();
                          });
                        } else
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text("Oops..! can't send an empty message"),
                              duration: Duration(milliseconds: 1500),
                            ),
                          );
                      },
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      message = value;
                    });
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
