import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hello/model/user_model.dart';
import 'package:hello/services/chat_service.dart';
import 'package:hello/services/user_service.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({key}) : super(key: key);

  @override
  _AddContactPageState createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("messagingUsers");

  CollectionReference chatCollection =
      FirebaseFirestore.instance.collection("chats");
  Widget result;

  String email = '';

  bool searching = false;

  var searchData;

  MessagingUser mUser;

  final String currentUserUid = FirebaseAuth.instance.currentUser.uid;

  String chatId;

  void _search(MessagingUser mUser) {
    if (!validEmail()) {
      setState(() {
        result = Text(
          "Invalid email address..!!",
          textAlign: TextAlign.center,
        );
      });
    } else if (email == FirebaseAuth.instance.currentUser.email) {
      setState(() {
        result = Text(
          "You cannot add your own mail address..!!",
          textAlign: TextAlign.center,
        );
      });
    } else {
      setState(() {
        searching = true;
      });

      if (mUser.contacts.contains(email)) {
        setState(() {
          searching = false;
          result = Text(
            "You already have a chat for the Entered email...!!",
            textAlign: TextAlign.center,
          );
        });
      } else {
        usersCollection.where("email", isEqualTo: email).get().then((value) {
          setState(() {
            searching = false;
          });
          if (value.size != 0) {
            searchData = value.docs.first.data() as Map<String, dynamic>;
            setState(() {
              result = Column(
                children: [
                  Text(
                    "results",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Full Name: ${searchData['fullName']}\nEmail :  ${searchData['email']}",
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            });
          } else
            setState(() {
              result = Text(
                "No user available, please check the email address you have entered..!!!",
                textAlign: TextAlign.center,
              );
            });
        });
      }
    }
  }

  Future<void> _addContact(MessagingUser mUser) async {
    if (searchData != null && validEmail()) {
      setState(() {
        result = CircularProgressIndicator();
      });

      if (mUser.contacts.contains(email)) {
        setState(() {
          result = Text(
            "You already have a chat for the Entered email ..!!",
            textAlign: TextAlign.center,
          );
        });
      } else
        await ChatService()
            .addNewChat([FirebaseAuth.instance.currentUser.email, email]).then(
                (String cid) {
          UserService().updateContactsChatIds(mUser, cid, email).then((status) {
            setState(() {
              result = Text("Contact added successfully");
            });
          });
        });
    }
  }

  bool validEmail() {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9.]{2,}$",
            caseSensitive: false, dotAll: true)
        .hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new Contact"),
      ),
      body: Center(
          child: StreamBuilder<DocumentSnapshot>(
        stream: UserService()
            .getMessagingUserAsStream(FirebaseAuth.instance.currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            mUser = MessagingUser.fromJson(snapshot.data);
            return Container(
              height: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: "enter email address",
                      prefixIcon: Icon(Icons.alternate_email_outlined),
                    ),
                    onChanged: (value) {
                      setState(() {
                        email = value.trim();
                      });
                    },
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: (result == null
                        ? SizedBox(
                            height: 25,
                          )
                        : (searching ? CircularProgressIndicator() : result)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DialogButton(
                        color: Colors.red,
                        icon: Icons.cancel,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      DialogButton(
                        icon: Icons.search,
                        color: (validEmail() ? Colors.amber : Colors.grey),
                        onPressed: () => _search(mUser),
                      ),
                      DialogButton(
                        icon: Icons.person_add_alt_1_sharp,
                        color: (searchData == null && !validEmail()
                            ? Colors.grey
                            : Colors.green),
                        onPressed: () => _addContact(mUser),
                      )
                    ],
                  ),
                  ElevatedButton(
                      onPressed: validEmail, child: Icon(Icons.badge))
                ],
              ),
            );
          } else
            return Text("Loading current User");
        },
      )),
    );
  }
}

class DialogButton extends StatelessWidget {
  const DialogButton({
    key,
    @required this.icon,
    @required this.color,
    @required this.onPressed,
  }) : super(key: key);

  final IconData icon;
  final Color color;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(color: this.color, shape: BoxShape.circle),
        child: Icon(
          this.icon,
          color: Colors.white,
          size: 25,
        ),
      ),
      onTap: this.onPressed,
    );
  }
}
