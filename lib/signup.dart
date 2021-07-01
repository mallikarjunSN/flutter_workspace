import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hello/auth/authentication.dart';
import 'package:hello/custom_widgets/anime_button.dart';
import 'package:hello/messaging/messaging_home.dart';
import 'package:hello/model/user_model.dart';
import 'package:hello/temp.dart';

class Signup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignupState();
  }
}

class SignupState extends State<Signup> {
  final _signupKey = GlobalKey<FormState>();

  String email;
  String password;
  String cPassword;

  String fullName;
  String userType;

  String error;

  List<String> ddItems = [UserType.DYSLEXIA, UserType.MESSAGING];

  AuthService _auth = AuthService();

  String status = "";

  final _ffStore = FirebaseFirestore.instance;

  User currentUser;

  Future<void> saveUserData() async {
    if (userType == UserType.MESSAGING) {
      await _ffStore
          .collection("messagingUsers")
          .doc(currentUser.uid.trim())
          .set({
        "fullName": fullName,
        "email": currentUser.email,
        "contacts": [],
        "chatIds": []
      });
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MessagingHome(),
          ));
    } else {
      await _ffStore
          .collection("dyslexiaUsers")
          .doc(currentUser.uid.trim())
          .set({
        "fullName": fullName,
        "email": currentUser.email,
      });
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Temp(),
          ));
    }
  }

  Future _alert(BuildContext context, String message) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 2000),
        elevation: 20,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$message ...!!",
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
      ),
    );
  }

  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Form(
          key: _signupKey,
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "SIGNUP",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 35,
                          fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.record_voice_over,
                      size: 50,
                      color: Colors.blue,
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: DropdownButton<String>(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        size: 30,
                      ),
                      hint: Text(
                        "Select User type",
                        textAlign: TextAlign.center,
                      ),
                      value: userType,
                      items: ddItems
                          .map((value) => DropdownMenuItem(
                              value: value,
                              child: Text(
                                value,
                                textAlign: TextAlign.center,
                              )))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          userType = val;
                        });
                      }),
                ),
                TextFormField(
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.blue,
                      size: 25,
                    ),
                    filled: true,
                    labelStyle: TextStyle(fontSize: 18),
                    hintText: "Full Name",
                    errorStyle: TextStyle(fontSize: 18),
                    contentPadding: EdgeInsets.all(10),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "please enter a valid name";
                    }
                    return null;
                  },
                  onChanged: (newValue) => setState(() {
                    fullName = newValue;
                  }),
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.alternate_email,
                        color: Colors.blue,
                        size: 25,
                      ),
                      filled: true,
                      labelStyle: TextStyle(fontSize: 18),
                      hintText: "email",
                      errorStyle: TextStyle(fontSize: 18),
                      contentPadding: EdgeInsets.all(10)),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "please enter an email address";
                    }
                    return null;
                  },
                  onChanged: (newValue) => setState(() {
                    email = newValue;
                  }),
                ),
                TextFormField(
                  style: TextStyle(fontSize: 18),
                  obscureText: !showPassword,
                  decoration: InputDecoration(
                      filled: true,
                      hintText: "password",
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Colors.blue,
                        size: 25,
                      ),
                      suffixIcon: IconButton(
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: (showPassword
                                ? Colors.blue
                                : Colors.black.withOpacity(0.25)),
                          ),
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          }),
                      errorStyle: TextStyle(fontSize: 18),
                      labelStyle: TextStyle(fontSize: 18),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      contentPadding: EdgeInsets.all(10)),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "please enter password";
                    }
                    return null;
                  },
                  onChanged: (newValue) => setState(() {
                    password = newValue;
                  }),
                ),
                TextFormField(
                  style: TextStyle(fontSize: 18),
                  obscureText: !showPassword,
                  decoration: InputDecoration(
                      filled: true,
                      hintText: "confirm password",
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Colors.blue,
                        size: 25,
                      ),
                      suffixIcon: IconButton(
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: (showPassword
                                ? Colors.blue
                                : Colors.black.withOpacity(0.25)),
                          ),
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          }),
                      labelStyle: TextStyle(fontSize: 18),
                      errorStyle: TextStyle(fontSize: 18),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      contentPadding: EdgeInsets.all(10)),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "please enter password";
                    }
                    return null;
                  },
                  onChanged: (newValue) => setState(() {
                    cPassword = newValue;
                  }),
                ),
                AnimeButton(
                  // color: Colors.cyan[800],
                  onPressed: () async {
                    if (_signupKey.currentState.validate()) {
                      if (userType == null)
                        _alert(context, "Select userType");
                      else if (password != cPassword) {
                        _alert(context, "passwords does not match");
                      } else {
                        setState(() {
                          status = "Creating account...";
                        });
                        await _auth.signUp(email, password).then((value) async {
                          if (value == "success") {
                            setState(() {
                              currentUser = FirebaseAuth.instance.currentUser;
                            });
                            saveUserData();
                          }
                          setState(() {
                            status = value;
                          });
                        });
                      }
                    }
                  },
                  child: Text(
                    "SUBMIT",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                (status == "Creating account..."
                    ? CircularProgressIndicator(
                        strokeWidth: 5,
                        backgroundColor: Colors.white,
                      )
                    : SizedBox()),
                Text(
                  status,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: (status == "success" ||
                              status == "Creating account..."
                          ? Colors.white
                          : Colors.red)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
