import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hello/custom_widgets/cool_color.dart';
import 'package:hello/custom_widgets/my_drawer.dart';
import 'package:hello/messaging/add_contact.dart';
import 'package:hello/messaging/messages_ui.dart';
import 'package:hello/model/chat_model.dart';
import 'package:hello/model/user_model.dart';
import 'package:hello/services/chat_service.dart';
import 'package:hello/services/string_service.dart';
import 'package:hello/services/user_service.dart';

class MessagingHome extends StatefulWidget {
  @override
  _MessagingHomeState createState() => _MessagingHomeState();
}

class _MessagingHomeState extends State<MessagingHome> {
  List<String> chatIds;
  final Query chats = FirebaseFirestore.instance
      .collection("messagingUsers")
      .where(FieldPath.documentId,
          isEqualTo: FirebaseAuth.instance.currentUser.uid);

  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("messagingUsers");

  void init() {
    chats.get().then((QuerySnapshot value) {
      var data = value.docs.first.data() as Map<String, dynamic>;

      if (data["chats"].length == 0) {
      } else {}
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _addContact() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddContactPage()));
  }

  final cr = FirebaseFirestore.instance.collection("chats");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(
        current: context.widget.toString(),
      ),
      // backgroundColor: Color.fromRGBO(50, 70, 78, 1.0),
      appBar: AppBar(
        title: Text("Messaging Home"),
        // backgroundColor: Color.fromRGBO(7, 50, 78, 1.0),
      ),
      floatingActionButton: Semantics(
        onTapHint: "add new contact",
        child: FloatingActionButton(
          tooltip: "Add new contact",
          child: Icon(Icons.person_add_alt_1_sharp),
          onPressed: _addContact,
        ),
      ),
      body: Center(
          child: StreamBuilder<DocumentSnapshot>(
        stream: UserService()
            .getMessagingUserAsStream(FirebaseAuth.instance.currentUser.uid),
        builder: (context, snap) {
          if (snap.hasData) {
            MessagingUser mUser = MessagingUser.fromJson(snap.data);
            if (mUser.chatIds.length == 0) {
              return Text("No chats, Please add new chats");
            } else
              return StreamBuilder<QuerySnapshot>(
                stream: ChatService().getAllChatDetails(mUser.chatIds),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  List<ChatDetails> allChats;
                  if (snapshot.hasData) {
                    allChats = snapshot.data.docs
                        .map((doc) => ChatDetails.fromJson(doc))
                        .toList();

                    int count = 0;

                    return ListView(
                      semanticChildCount: allChats.length,
                      addSemanticIndexes: true,
                      children: allChats.map((chat) {
                        count++;
                        return Semantics(
                            label: "chat $count of ${allChats.length}",
                            child: ChatTile(cd: chat));
                      }).toList(),
                    );
                  } else if (snapshot.hasError) {
                    return Text("Some Error");
                  } else
                    return Text("Loading");
                },
              );
          } else if (snap.hasError) {
            return Text(snap.error.toString());
          } else
            return CircularProgressIndicator();
        },
      )),
    );
  }
}

class ChatTile extends StatefulWidget {
  ChatTile({
    key,
    @required this.cd,
  }) : super(key: key);

  final ChatDetails cd;

  @override
  _ChatTileState createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  String contactName;

  void showDp() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Semantics(
              image: true,
              onTapHint: "close.",
              hint: "viewing display picture of $contactName .",
              excludeSemantics: true,
              onTap: () {
                Navigator.pop(context);
              },
              child: SizedBox(
                child: Stack(
                  children: [
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Semantics(
                        excludeSemantics: true,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: Colors.white,
                          icon: Icon(Icons.close),
                        ),
                      ),
                    ),
                    Image.asset(
                      "assets/user.png",
                      fit: BoxFit.fill,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  bool longPressed = false;

  @override
  Widget build(BuildContext context) {
    String lastMessage;
    String lastMessageOn;
    int newMessagesCount;

    if (widget.cd.lastMessageOn != null) {
      lastMessage = widget.cd.lastMessage;
      lastMessageOn = StringService().getTimeString(widget.cd.lastMessageOn);
    } else {
      lastMessage = "Start messaging";
    }
    return Semantics(
      label: "with $contactName .",
      onTapHint: "view chat or send new messages.",
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              tileColor: Colors.black.withOpacity(0.05),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MessagesUI(
                      chatId: widget.cd.chatId,
                      contactName: StringService().capitalize(contactName),
                    ),
                  ),
                );
              },
              contentPadding:
                  EdgeInsets.only(bottom: 2.5, top: 2.5, left: 5, right: 5),
              leading: FloatingActionButton(
                tooltip: "view display picture of $contactName",
                heroTag: null,
                child: Container(
                  padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Image.asset(
                    "assets/user.png",
                    fit: BoxFit.cover,
                  ),
                ),
                onPressed: showDp,
              ),
              subtitle: FutureBuilder(
                future: ChatService().getRecentMessage(widget.cd.chatId),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    Map<String, dynamic> data;

                    DateTime time = (widget.cd.lastMessageOn == null
                        ? null
                        : widget.cd.lastMessageOn.toDate());
                    bool lastSent;
                    if (snapshot.data.docs.length == 0) {
                      lastSent = true;
                    } else {
                      data = snapshot.data.docs.first.data();
                      lastSent = (data["authorUid"] ==
                          FirebaseAuth.instance.currentUser.uid);
                      newMessagesCount = widget.cd.newMessagesCount;
                    }
                    return Semantics(
                      hint: "last message $lastMessage.",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Semantics(
                            excludeSemantics: true,
                            child: Text(
                              StringService().formatLongMessage(lastMessage) ??
                                  "Start messaging",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.cyan,
                              ),
                            ),
                          ),
                          Semantics(
                            label: (time == null
                                ? "new chat ."
                                : "last message on ${(time.hour) % 12} ${time.minute}."),
                            excludeSemantics: true,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                (lastSent || newMessagesCount == 0
                                    ? SizedBox()
                                    : Container(
                                        padding: EdgeInsets.all(7),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: CoolColor.primaryColor),
                                        child: Text(
                                          newMessagesCount.toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  lastMessageOn == null
                                      ? "new chat"
                                      : lastMessageOn,
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text("Error");
                  }
                  return Text("Loading...");
                },
              ),
              title: Semantics(
                excludeSemantics: true,
                child: FutureBuilder<MessagingUser>(
                  future: UserService().getMessagingUserByEmail(
                      (widget.cd.participantsEmail[0] ==
                              FirebaseAuth.instance.currentUser.email
                          ? widget.cd.participantsEmail[1]
                          : widget.cd.participantsEmail[0])),
                  builder: (context, snapshot) {
                    MessagingUser messagingUser = snapshot.data;
                    if (snapshot.hasData) {
                      contactName = messagingUser.fullName;
                      return Text(
                        StringService().capitalize(contactName),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      );
                    } else if (snapshot.hasError) {
                      return Text("Error");
                    } else
                      return Text("Loading..");
                  },
                ),
              ),
            ),
            Divider(
              indent: 75,
              endIndent: 60,
              thickness: 1.5,
              height: 5,
            )
          ],
        ),
      ),
    );
  }
}
