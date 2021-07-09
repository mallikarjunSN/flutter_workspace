import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hello/auth/authentication.dart';
import 'package:hello/custom_widgets/anime_button.dart';
import 'package:hello/model/user_model.dart';
import 'package:hello/services/user_service.dart';
import 'package:hello/verify_email.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignupState();
  }
}

class InfoClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;
    Path path = Path();

    RRect rRect = RRect.fromLTRBAndCorners(
      0,
      height * 0.15,
      width,
      height,
      bottomLeft: Radius.circular(15),
      bottomRight: Radius.circular(15),
      topLeft: Radius.circular(15),
      topRight: Radius.circular(15),
    );

    path.moveTo(0, height * 0.4);
    path.addRRect(rRect);
    path.lineTo(width * 0.75, height * 0.15);
    path.lineTo(width * 0.8, 0);
    path.lineTo(width * 0.85, height * 0.15);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}

class IOType {
  static const String VOICE_IO = "Voice I/O";
  static const String TEXT_IO = "Text I/O";
}

class SignupState extends State<Signup> {
  final _signupKey = GlobalKey<FormState>();

  String fullName;
  String email;
  String password;
  String cPassword;
  String userType;
  String ioType;

  String error;

  bool searching = false;

  List<String> ddItems = [UserType.DYSLEXIA, UserType.MESSAGING];
  List<String> ioTypes = [IOType.TEXT_IO, IOType.VOICE_IO];

  AuthService _auth = AuthService();

  bool busy = false;

  final _ffStore = FirebaseFirestore.instance;

  User currentUser;

  Future<void> saveUserData() async {
    await UserService().saveUsertype(userType == UserType.MESSAGING);
    if (userType == UserType.MESSAGING)
      await _ffStore
          .collection("messagingUsers")
          .doc(currentUser.uid.trim())
          .set({
        "fullName": fullName,
        "email": currentUser.email,
        "ioType": ioType,
        "contacts": [],
        "chatIds": []
      }).then((value) {
        currentUser.sendEmailVerification();
      });
    else {
      await _ffStore
          .collection("dyslexiaUsers")
          .doc(currentUser.uid.trim())
          .set({
        "fullName": fullName,
        "email": currentUser.email,
        "avgAccuracy": 0.0,
      }).then((value) {
        currentUser.sendEmailVerification();
      });
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => VerifyEmail(),
      ),
    );
  }

  void _alert(BuildContext context, String message) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            )
          ],
          title: Text(
            "ERROR",
            style: TextStyle(
              fontSize: 25,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message ?? "",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  bool showPassword = false;

  double height, width;

  Map<String, String> errorMessage = {
    "email-already-in-use":
        "Entered email-id is being used by another user, Please use different email-id"
  };

  void signUp() async {
    if (_signupKey.currentState.validate()) {
      setState(() {
        busy = true;
      });
      await _auth.signUp(email, password).then((value) async {
        if (value == "success") {
          setState(() {
            currentUser = FirebaseAuth.instance.currentUser;
          });
          saveUserData();
        } else {
          _alert(context, errorMessage[value] ?? "Error");
        }
        setState(() {
          busy = false;
        });
      });
    }
  }

  int current = 0;

  bool validEmail() {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9.]{2,}$",
            caseSensitive: false, dotAll: true)
        .hasMatch(email);
  }

  void verifyAndNext() {
    switch (current) {
      case 0:
        if (userType == null) {
          _alert(context, "Please select UserType");
        } else if (userType == UserType.MESSAGING && ioType == null) {
          _alert(context, "Please select prefered Input/Output Type");
        } else {
          setState(() {
            current += 1;
          });
        }
        break;
      case 2:
        if (email == null) {
          _alert(context, "Email cannot be empty");
        } else if (!validEmail()) {
          _alert(context, "Please enter valid email-id");
        } else {
          setState(() {
            current += 1;
          });
        }
        break;
      case 1:
        print(fullName);
        if (fullName == null || fullName.isEmpty) {
          _alert(context, "Name cannot be empty");
        } else {
          setState(() {
            current += 1;
          });
        }
        break;
      case 3:
        if (password == null || password.length < 6) {
          _alert(context, "Password cannot be less than 6 characters");
        } else if (password != cPassword) {
          _alert(context, "Both passwords should be same");
        } else {
          signUp();
        }
        break;
      default:
    }
  }

  bool moreInfo1 = false;
  bool moreInfo2 = false;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: height,
        width: width,
        child: Form(
          key: _signupKey,
          child: Stack(
            children: [
              Image.network(
                "https://i.pinimg.com/originals/fd/e6/03/fde603acbda0f7f1c2cc806890b68476.jpg",
                height: height,
                width: width,
                fit: BoxFit.fill,
              ),
              Positioned(
                top: height * 0.25,
                right: 10,
                left: 10,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: height * 0.4),
                      child: Container(
                        width: width,
                        height: 100,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                        ),
                        alignment: Alignment.center,
                        child: IndexedStack(
                          index: current,
                          alignment: AlignmentDirectional.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  children: [
                                    DropdownButton<String>(
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
                                    IconButton(
                                      icon: Icon(Icons.info),
                                      onPressed: () {
                                        setState(() {
                                          moreInfo2 = false;
                                          moreInfo1 = !moreInfo1;
                                        });
                                      },
                                    ),
                                    (moreInfo1
                                        ? ClipPath(
                                            clipper: InfoClipper(),
                                            child: Container(
                                              width: width * 0.8,
                                              height: height * 0.15,
                                              color: Colors.white,
                                              padding: EdgeInsets.only(top: 20),
                                              child: Text(
                                                'If you are person with dyslexia, and want to use app as "Learning Hub" select "Dyslexia User" \n\nOtherwise, Select "Messaging User"',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          )
                                        : SizedBox())
                                  ],
                                ),
                                (userType == UserType.MESSAGING
                                    ? Wrap(
                                        alignment: WrapAlignment.spaceEvenly,
                                        children: [
                                          DropdownButton<String>(
                                              icon: Icon(
                                                Icons.arrow_drop_down,
                                                size: 30,
                                              ),
                                              hint: Text(
                                                "Select I/O type",
                                                textAlign: TextAlign.center,
                                              ),
                                              value: ioType,
                                              items: ioTypes
                                                  .map((value) =>
                                                      DropdownMenuItem(
                                                          value: value,
                                                          child: Text(
                                                            value,
                                                            textAlign: TextAlign
                                                                .center,
                                                          )))
                                                  .toList(),
                                              onChanged: (val) {
                                                setState(() {
                                                  ioType = val;
                                                });
                                              }),
                                          IconButton(
                                            icon: Icon(Icons.info),
                                            onPressed: () {
                                              setState(() {
                                                moreInfo1 = false;
                                                moreInfo2 = !moreInfo2;
                                              });
                                            },
                                          ),
                                          (moreInfo2
                                              ? ClipPath(
                                                  clipper: InfoClipper(),
                                                  child: Container(
                                                    width: width * 0.8,
                                                    height: height * 0.15,
                                                    color: Colors.white,
                                                    padding: EdgeInsets.only(
                                                        top: 20),
                                                    child: Text(
                                                      'If you have blindness, and prefer Voice input and out, select "Voice I/O" \n\nOtherwise, Select "Text I/O"',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : SizedBox())
                                        ],
                                      )
                                    : SizedBox())
                              ],
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.blue,
                                    size: 25,
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  filled: true,
                                  labelStyle: TextStyle(fontSize: 18),
                                  hintText: "Your full name",
                                  errorStyle: TextStyle(fontSize: 14),
                                  contentPadding: EdgeInsets.all(10)),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Name cannot be empty";
                                }
                                return null;
                              },
                              onChanged: (name) => setState(() {
                                fullName = name.trim();
                              }),
                            ),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(fontSize: 18),
                              initialValue: (email == null ? "" : email),
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.alternate_email,
                                    color: Colors.blue,
                                    size: 25,
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  filled: true,
                                  labelStyle: TextStyle(fontSize: 18),
                                  hintText: "email",
                                  errorStyle: TextStyle(fontSize: 14),
                                  contentPadding: EdgeInsets.all(10)),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "please enter an email address";
                                }
                                return null;
                              },
                              onChanged: (newValue) => setState(() {
                                email = newValue.trim();
                              }),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
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
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30))),
                                      suffixIcon: IconButton(
                                          icon: Icon(
                                            Icons.remove_red_eye,
                                            color: (showPassword
                                                ? Colors.blue
                                                : Colors.black
                                                    .withOpacity(0.25)),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              showPassword = !showPassword;
                                            });
                                          }),
                                      errorStyle: TextStyle(fontSize: 14),
                                      labelStyle: TextStyle(fontSize: 18),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
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
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30))),
                                      suffixIcon: IconButton(
                                          icon: Icon(
                                            Icons.remove_red_eye,
                                            color: (showPassword
                                                ? Colors.blue
                                                : Colors.black
                                                    .withOpacity(0.25)),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              showPassword = !showPassword;
                                            });
                                          }),
                                      labelStyle: TextStyle(fontSize: 18),
                                      errorStyle: TextStyle(fontSize: 14),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      contentPadding: EdgeInsets.all(10)),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "please confirm password";
                                    }
                                    return null;
                                  },
                                  onChanged: (newValue) => setState(() {
                                    cPassword = newValue;
                                  }),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 50,
                left: width / 3,
                child: Text(
                  "SIGNUP",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Positioned(
                bottom: height * 0.25,
                left: width / 2 - 25,
                child: (!busy
                    ? SizedBox(
                        height: 0,
                        width: 0,
                      )
                    : CircularProgressIndicator(
                        strokeWidth: 5,
                        backgroundColor: Colors.white,
                      )),
              ),
              Positioned(
                bottom: height * 0.15,
                right: 0,
                left: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    (current == 0
                        ? SizedBox(
                            width: width * 0.3,
                          )
                        : AnimeButton(
                            width: width * 0.4,
                            onPressed: () {
                              setState(() {
                                current -= 1;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.arrow_back_ios),
                                Text(
                                  "Previous",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )),
                    (current < 3
                        ? AnimeButton(
                            width: width * 0.4,
                            onPressed: verifyAndNext,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Next",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                Icon(Icons.arrow_forward_ios),
                              ],
                            ),
                          )
                        : AnimeButton(
                            width: width * 0.3,
                            onPressed: verifyAndNext,
                            backgroundColor: Colors.green,
                            child: Text(
                              "SUBMIT",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
