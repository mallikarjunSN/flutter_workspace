import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hello/services/chat_service.dart';

class MessagesUI extends StatefulWidget {
  MessagesUI({@required this.chatId, @required this.contactName, key})
      : super(key: key);

  final String chatId;

  final String contactName;

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

  Message.fromJsom(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    this.authorUid = data["authorUid"];
    this.content = data["content"];
    this.status = data["status"];
    this.time = data["time"];
  }
}

class _MessagesUIState extends State<MessagesUI> {
  String message = '';
  List<Message> messages = [];

  var textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  final User currentUser = FirebaseAuth.instance.currentUser;

  void sendMessage() {
    Message msg = Message(
      authorUid: currentUser.uid,
      content: message,
      time: Timestamp.now(),
      status: 1,
    );
    ChatService()
        .addMessage(
      widget.chatId,
      msg,
    )
        .then((value) {
      setState(() {
        message = '';
        textEditingController.clear();
      });
    });
  }

  int linesCount = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [Text(widget.contactName ?? "ugh"), Icon(Icons.chat)],
        ),
        centerTitle: true,
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: ChatService().getMessagesStream(widget.chatId.trim()),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              print(widget.chatId);
              print(snapshot.data.docs.length);
              return Stack(
                fit: StackFit.expand,
                children: [
                  (snapshot.data.docs.length == 0
                      ? Center(child: Text("No Messages, start now..!!"))
                      : Positioned(
                          top: 0,
                          bottom: 60,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.94,
                            width: MediaQuery.of(context).size.width,
                            child: ListView(
                                reverse: true,
                                shrinkWrap: true,
                                children: snapshot.data.docs.map((doc) {
                                  var msg = Message.fromJsom(
                                    doc,
                                  );
                                  return MessageContainer(
                                      message: msg,
                                      currentUserUid: currentUser.uid);
                                }).toList()),
                          ),
                        )),
                  Positioned(
                    bottom: 4,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: linesCount + 5,
                        minLines: 1,
                        controller: textEditingController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.emoji_emotions,
                            color: Colors.amber,
                          ),
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.all(5),
                          hintText: "Type your message here....",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
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
                              } else
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Oops..! can't send an empty message"),
                                    duration: Duration(milliseconds: 1500),
                                  ),
                                );
                            },
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            message = val;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else
              return Text("error");
          },
        ),
      ),
    );
  }
}

class MessageContainer extends StatelessWidget {
  const MessageContainer({
    @required this.message,
    @required this.currentUserUid,
    key,
  }) : super(key: key);

  final Message message;

  final String currentUserUid;

  String getTimeString(Timestamp time) {
    return time.toDate().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: (currentUserUid == message.authorUid
          ? Alignment.centerRight
          : Alignment.centerLeft),
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.cyan,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message.content ?? "default",
                style: TextStyle(fontSize: 18),
                textAlign: (currentUserUid == message.authorUid
                    ? TextAlign.right
                    : TextAlign.left),
              ),
              Text(
                getTimeString(message.time),
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
