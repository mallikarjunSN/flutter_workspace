import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hello/custom_widgets/my_drawer.dart';
import 'package:hello/messaging/add_contact.dart';
import 'package:hello/messaging/messages_ui.dart';
import 'package:hello/model/chat_model.dart';
import 'package:hello/model/user_model.dart';
import 'package:hello/services/chat_details_service.dart';
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
      backgroundColor: Color.fromRGBO(50, 70, 78, 1.0),
      appBar: AppBar(
        title: Text("Messaging Home"),
        backgroundColor: Color.fromRGBO(7, 50, 78, 1.0),
        actions: [
          TextButton(
            child: Icon(
              Icons.search,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {},
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.person_add_alt_1_sharp),
        onPressed: _addContact,
      ),
      body: Center(
          child: FutureBuilder<MessagingUser>(
        future: UserService()
            .getMessagingUserById(FirebaseAuth.instance.currentUser.uid),
        builder: (context, snap) {
          if (snap.hasData) {
            MessagingUser mUser = snap.data;
            if (mUser.chatIds.length == 0) {
              return Text("No chats, Please add new chats");
            } else
              return StreamBuilder<QuerySnapshot>(
                stream: ChatDetailsService().getAllChatDetails(mUser.chatIds),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  List<ChatDetails> allChats;
                  if (snapshot.hasData) {
                    allChats = snapshot.data.docs
                        .map((doc) => ChatDetails.fromJson(doc))
                        .toList();

                    return ListView(
                      children: allChats.map((chat) {
                        return ChatTile(cd: chat);
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

class ChatTile extends StatelessWidget {
  ChatTile({
    key,
    @required this.cd,
  }) : super(key: key);

  final ChatDetails cd;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => MessagesUI()));
      },
      child: Container(
        width: double.infinity,
        child: ListTile(
          contentPadding: EdgeInsets.only(top: 5, bottom: 5),
          leading: GestureDetector(
              child: Container(
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Image.asset(
                  "assets/user.png",
                  height: 70,
                  width: 70,
                ),
              ),
              onTap: () {}),
          subtitle: Text(
            cd.lastMessage ?? "Start messaging",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
          title: FutureBuilder<MessagingUser>(
            future: UserService().getMessagingUserByEmail(
                (cd.participantsEmail[0] ==
                        FirebaseAuth.instance.currentUser.email
                    ? cd.participantsEmail[1]
                    : cd.participantsEmail[0])),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                  snapshot.data.fullName,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                );
              } else if (snapshot.hasError) {
                return Text("Error");
              } else
                return Text("Loading..");
            },
          ),
          trailing: Text(
            cd.lastMessageOn == null
                ? "new chat"
                : cd.lastMessageOn.toDate().toString(),
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
        decoration: BoxDecoration(border: Border.all(width: 0.1)),
      ),
    );
  }
}
