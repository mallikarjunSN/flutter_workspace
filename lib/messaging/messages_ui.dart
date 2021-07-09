import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hello/services/chat_service.dart';
import 'package:hello/services/string_service.dart';

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
        title: Text(StringService().capitalize(widget.contactName) ?? "ugh"),
        actions: [
          IconButton(
            icon: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.block_outlined,
                  color: Colors.red,
                  size: 25,
                ),
                Icon(
                  Icons.block_outlined,
                  color: Colors.red,
                  size: 21,
                ),
              ],
            ),
            onPressed: () {},
          )
        ],
        centerTitle: true,
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: ChatService().getMessagesStream(widget.chatId.trim()),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
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

class ChatBubble extends CustomPainter {
  final Color color;
  final Alignment alignment;

  ChatBubble({
    @required this.color,
    this.alignment,
  });

  var _radius = 10.0;
  var _x = 10.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (alignment == Alignment.centerRight) {
      canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            0,
            0,
            size.width - 8,
            size.height,
            bottomLeft: Radius.circular(_radius),
            topRight: Radius.circular(_radius),
            topLeft: Radius.circular(_radius),
          ),
          Paint()
            ..color = this.color
            ..style = PaintingStyle.fill);
      var path = new Path();
      path.moveTo(size.width - _x, size.height - 20);
      path.lineTo(size.width - _x, size.height);
      path.lineTo(size.width, size.height);
      canvas.clipPath(path);
      canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            size.width - _x,
            0.0,
            size.width,
            size.height,
            topRight: Radius.circular(_radius),
          ),
          Paint()
            ..color = this.color
            ..style = PaintingStyle.fill);
    } else {
      canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            _x,
            0,
            size.width,
            size.height,
            bottomRight: Radius.circular(_radius),
            topRight: Radius.circular(_radius),
            topLeft: Radius.circular(_radius),
          ),
          Paint()
            ..color = this.color
            ..style = PaintingStyle.fill);
      var path = new Path();
      path.moveTo(0, size.height);
      path.lineTo(_x, size.height);
      path.lineTo(_x, size.height - 20);
      canvas.clipPath(path);
      canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            0,
            0.0,
            _x,
            size.height,
            topRight: Radius.circular(_radius),
          ),
          Paint()
            ..color = this.color
            ..style = PaintingStyle.fill);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class MessageContainer extends StatefulWidget {
  MessageContainer({
    @required this.message,
    @required this.currentUserUid,
    key,
  }) : super(key: key);

  final Message message;

  final String currentUserUid;

  @override
  _MessageContainerState createState() => _MessageContainerState();
}

class _MessageContainerState extends State<MessageContainer> {
  bool received = false;

  Alignment alignment = Alignment.centerRight;

  @override
  Widget build(BuildContext context) {
    received = widget.currentUserUid != widget.message.authorUid;
    alignment = (received ? Alignment.centerLeft : Alignment.centerRight);
    return Align(
      alignment: alignment,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        margin: EdgeInsets.only(bottom: 5),
        child: CustomPaint(
          painter: ChatBubble(
              color: Colors.green.withOpacity(0.5), alignment: alignment),
          child: Container(
            padding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      widget.message.content ?? "default",
                      style: TextStyle(fontSize: 18),
                      textAlign: (!received ? TextAlign.right : TextAlign.left),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                          ),
                          Text(
                            widget.message.time.toDate().day.toString(),
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                      Text(
                        StringService().getTimeString(widget.message.time),
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      (received
                          ? SizedBox()
                          : Icon(
                              (widget.message.status == 1
                                  ? Icons.check
                                  : Icons.remove_red_eye_rounded),
                              size: 14,
                            ))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
