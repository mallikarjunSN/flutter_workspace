import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hello/custom_widgets/anime_button.dart';
import 'package:hello/model/chat_model.dart';
import 'package:hello/model/user_model.dart';
import 'package:hello/services/chat_service.dart';
import 'package:hello/services/string_service.dart';
import 'package:hello/services/tts_service.dart';
import 'package:hello/services/user_service.dart';
import 'package:hello/signup.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

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

  String word = "";

  bool _hasSpeech = false;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  final SpeechToText speech = SpeechToText();

  String _text = 'Press the mic button and start speaking';

  @override
  void initState() {
    super.initState();
    initSpeechState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );

    if (!mounted) return;
    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  Future<void> startListening() async {
    lastError = "";
    lastWords = "";
    await speech.listen(
      onResult: resultListener,
    );
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
      _text = lastWords;
    });

    if (!speech.isListening) {
      showDialog(
          context: context,
          builder: (context) {
            return Builder(
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    lastWords == null || lastWords.isEmpty
                        ? "Sorry, could not recognize please try again"
                        : "Message recognized\n $lastWords",
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    Semantics(
                      label: "cancel button. double tap to close",
                      excludeSemantics: true,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel"),
                      ),
                    ),
                    (lastWords == null || lastWords.isEmpty
                        ? Semantics(
                            label: "close button. double tap to close",
                            excludeSemantics: true,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("close"),
                            ),
                          )
                        : Semantics(
                            label:
                                "send button. double tap to confirm and send",
                            excludeSemantics: true,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  message = lastWords;
                                });
                                sendMessage();
                                Navigator.pop(context);
                              },
                              child: Text("send"),
                            ),
                          ))
                  ],
                );
              },
            );
          });
    }
  }

  void stopListening() {
    speech.stop();
    setState(() {});
  }

  void cancelListening() {
    speech.cancel();
    setState(() {});
  }

  void errorListener(SpeechRecognitionError error) {
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    setState(() {
      lastStatus = "$status";
    });
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
      if (voiceIo) _ttsService.speak("Message sent successfully");
    });
  }

  Future<void> unBlock(String chatId) async {
    await ChatService().unBlock(chatId);
  }

  void block(String chatId) {
    if (blocked) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "This chat is already Blocked..!!",
              textAlign: TextAlign.center,
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("OK"))
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Do you want block this chat??",
              textAlign: TextAlign.center,
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Semantics(
                  button: true,
                  label: "confirm",
                  onTapHint: "confirm blocking",
                  child: AnimeButton(
                    backgroundColor: Colors.red,
                    onPressed: () async {
                      await ChatService().block(chatId);
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Yes",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Semantics(
                  button: true,
                  label: "cancel",
                  onTapHint: "cancel blocking",
                  child: AnimeButton(
                    backgroundColor: Colors.green,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "No",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  TtsService _ttsService;

  Future<void> inputMessage() async {
    _ttsService = TtsService();
    if (voiceIo) {
      await _ttsService.speak("speak message after mic beep");
    }
    await startListening();
  }

  int linesCount = 1;

  bool blocked = true;

  String blockerUid;

  bool voiceIo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringService().capitalize(widget.contactName) ?? "ugh"),
        actions: [
          Semantics(
            child: Semantics(
              label: "block chat",
              onTapHint: "block chat with ${widget.contactName}",
              child: IconButton(
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
                onPressed: () {
                  block(widget.chatId);
                },
              ),
            ),
          )
        ],
        centerTitle: true,
      ),
      floatingActionButton: FutureBuilder<DocumentSnapshot>(
        future: UserService()
            .getMessagingUser(FirebaseAuth.instance.currentUser.uid),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            MessagingUser mUser = MessagingUser.fromJson(snapshot.data);
            if (mUser.ioType == IOType.VOICE_IO) {
              voiceIo = true;
              return Semantics(
                  label:
                      "input message button. double tap to input new message in voice format",
                  excludeSemantics: true,
                  child: FloatingActionButton(
                    onPressed: () {
                      inputMessage();
                    },
                    child: Icon(Icons.mic),
                  ));
            } else {
              return SizedBox();
            }
          } else
            return SizedBox();
        },
      ),
      body: Center(
        child: StreamBuilder(
          stream: ChatService().getChatDetailsAsStream(widget.chatId),
          builder: (context, AsyncSnapshot cdSnapshot) {
            ChatDetails cd;
            if (cdSnapshot.hasData) {
              cd = ChatDetails.fromJson(cdSnapshot.data);
              if (cd.lastAuthorUid != FirebaseAuth.instance.currentUser.uid) {
                ChatService().markAsRead(widget.chatId);
              }
              blocked = cd.blocked;
              if (cd.blocked &&
                  cd.blockerUid != FirebaseAuth.instance.currentUser.uid) {
                if (voiceIo) {
                  _ttsService.speak(
                      "This chat has been blocked by the other user ..!!!");
                }
                return Text(
                  "This chat has been blocked by the other user ..!!!",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                );
              } else if (cd.blocked &&
                  cd.blockerUid == FirebaseAuth.instance.currentUser.uid) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "You have blocked this chat..!!!",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Semantics(
                      label: "unblock chat",
                      onTapHint: "unblock chat with ${widget.contactName}",
                      excludeSemantics: true,
                      child: ElevatedButton(
                          onPressed: () => unBlock(widget.chatId),
                          child: Text("Unblock")),
                    ),
                  ],
                );
              } else
                return StreamBuilder<QuerySnapshot>(
                  stream: ChatService().getMessagesStream(widget.chatId.trim()),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> messagesSnapshot) {
                    if (messagesSnapshot.hasData) {
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          (messagesSnapshot.data.docs.length == 0
                              ? Center(
                                  child: Text("No Messages, start now..!!"))
                              : Positioned(
                                  top: 0,
                                  bottom: 60,
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.94,
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView(
                                        reverse: true,
                                        shrinkWrap: true,
                                        semanticChildCount:
                                            messagesSnapshot.data.docs.length,
                                        addSemanticIndexes: true,
                                        children: messagesSnapshot.data.docs
                                            .map((doc) {
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
                            bottom: 8,
                            child: SizedBox(
                              width: (voiceIo
                                  ? MediaQuery.of(context).size.width * 0.75
                                  : MediaQuery.of(context).size.width),
                              child: TextFormField(
                                keyboardType: TextInputType.multiline,
                                maxLines: linesCount + 5,
                                minLines: 1,
                                controller: textEditingController,
                                decoration: InputDecoration(
                                  // prefixIcon: Icon(
                                  //   Icons.emoji_emotions,
                                  //   color: Colors.amber,
                                  // ),
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.all(5),
                                  hintText: "Type your message here",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  suffixIcon: IconButton(
                                    tooltip: "send",
                                    icon: Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.blue),
                                        child: Icon(
                                          Icons.send,
                                          color: Colors.white,
                                        )),
                                    onPressed: () {
                                      if (message.isNotEmpty) {
                                        sendMessage();
                                      } else
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                "Oops..! can't send an empty message"),
                                            duration:
                                                Duration(milliseconds: 1500),
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
                    } else if (messagesSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else
                      return Text("error");
                  },
                );
            } else {
              return CircularProgressIndicator();
            }
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

  DateTime time;

  @override
  Widget build(BuildContext context) {
    received = widget.currentUserUid != widget.message.authorUid;
    alignment = (received ? Alignment.centerLeft : Alignment.centerRight);
    String str = (received ? "received" : "sent");
    time = widget.message.time.toDate();
    return Align(
      alignment: alignment,
      child: Semantics(
        label:
            "${widget.message.content} $str on ${(time.hour) % 12} ${time.minute}",
        excludeSemantics: true,
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
                        textAlign:
                            (!received ? TextAlign.right : TextAlign.left),
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
      ),
    );
  }
}
