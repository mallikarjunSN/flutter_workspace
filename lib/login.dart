import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hello/auth/authentication.dart';
import 'package:hello/custom_widgets/anime_button.dart';
import 'package:hello/dyslexia/dyslexia_home.dart';
import 'package:hello/messaging/messaging_home.dart';
import 'package:hello/services/user_service.dart';
import 'package:hello/signup.dart';
import 'package:hello/verify_email.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  final _loginKey = GlobalKey<FormState>();
  String email;
  String password;
  String error;

  // DatabaseReference _testRef =
  //     FirebaseDatabase.instance.reference().child("test");

  List<String> ddItems = ["Specially Abled", "Differently Abled", "Messaging"];
  String selectedValue;

  /*final dropDown = new ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      child: Container(
        alignment: Alignment.center,
        color: Colors.white,
        width: double.infinity,
        child: DropdownButton(
          // isExpanded: true,
          // icon: Icon(Icons.zoom_in),
          // underline: ,
          hint: Text(
            "Select a value",
            textAlign: TextAlign.center,
          ),
          // value: selectedValue,
          // // items: ddItems
          //     .map((value) => DropdownMenuItem(
          //         value: value,
          //         child: Text(
          //           value,
          //           textAlign: TextAlign.center,
          //         )))
          //     .toList(),
          // onChanged: (val) {
          //   setState(() {
          //     selectedValue = val;
          //   });
          // }),
        ),
      ));
      */

  // void validate() {
  //   if (_loginKey.currentState.validate()) {}
  // }
  AuthService _auth = AuthService();

  String status = " ";

  bool showPassword = false;

  void login() async {
    if (_loginKey.currentState.validate()) {
      setState(() {
        status = "Signing in...";
      });
      await _auth.signIn(email, password).then((value) {
        setState(() {
          status = value;
        });
        if (status == "success") {
          bool emailVerified = FirebaseAuth.instance.currentUser.emailVerified;

          if (emailVerified) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => VerifyEmail(),
              ),
            );
          } else {
            UserService()
                .getUserTypeByEmail(FirebaseAuth.instance.currentUser.email)
                .then((isMessagingUser) async {
              await UserService().saveUsertype(isMessagingUser);
              if (isMessagingUser) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => MessagingHome(),
                  ),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => DyslexiaHome(),
                  ),
                );
              }
            });
          }
        }
      });
    }
  }

  double width, height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            "https://i.pinimg.com/originals/e3/e5/b1/e3e5b121a4a6d008971cccbd3088ef01.jpg",
            fit: BoxFit.fill,
            height: height,
            width: width,
          ),
          Positioned(
            top: 50,
            width: width,
            child: Text(
              "welcome to",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          Positioned(
            top: 100,
            width: width,
            child: Text(
              "VOX",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.cyan,
                fontWeight: FontWeight.bold,
                fontSize: 50,
              ),
            ),
          ),
          Positioned(
            top: height * 0.25,
            left: 0,
            right: 0,
            bottom: height * 0.3,
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Form(
                    key: _loginKey,
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 50, bottom: 5, left: 10, right: 10),
                      color: Colors.white.withOpacity(0.25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.alternate_email_outlined,
                                size: 25,
                              ),
                              hintStyle:
                                  TextStyle(fontSize: 18, color: Colors.white),
                              labelStyle:
                                  TextStyle(fontSize: 10, color: Colors.white),
                              hintText: "email",
                              errorStyle:
                                  TextStyle(fontSize: 16, color: Colors.red),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              contentPadding: EdgeInsets.all(10),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "please enter an email address";
                              }

                              return null;
                            },
                            onChanged: (newValue) => setState(
                              () {
                                email = newValue;
                              },
                            ),
                          ),
                          TextFormField(
                            style: TextStyle(fontSize: 18),
                            obscureText: !showPassword,
                            decoration: InputDecoration(
                                hintStyle: TextStyle(
                                    color: Colors.white, fontSize: 18),
                                hintText: "password",
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  size: 25,
                                ),
                                suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.remove_red_eye,
                                      color: (!showPassword
                                          ? Colors.black.withOpacity(0.5)
                                          : Colors.blue),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        showPassword = !showPassword;
                                      });
                                    }),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                labelStyle: TextStyle(fontSize: 18),
                                errorStyle:
                                    TextStyle(fontSize: 16, color: Colors.red),
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
                          AnimeButton(
                            height: 60,
                            width: 90,
                            backgroundColor: Colors.amberAccent,
                            onPressed: login,
                            child: Text(
                              "Login",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: height * 0.21,
            width: width,
            child: (status == "Signing in..."
                ? Center(
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(
                        strokeWidth: 5,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  )
                : SizedBox(
                    height: 0,
                    width: 0,
                  )),
          ),
          Positioned(
            bottom: height * 0.18,
            width: width,
            child: Center(
              child: Text(
                status,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: (status == "success" || status == "Signing in..."
                        ? Colors.white
                        : Colors.red)),
              ),
            ),
          ),
          Positioned(
            bottom: height * 0.01,
            left: width / 2.7,
            child: AnimeButton(
              backgroundColor: Colors.blue,
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Signup()));
              },
              child: Text(
                "Signup",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Tempo extends StatefulWidget {
  Tempo({key}) : super(key: key);

  @override
  _TempoState createState() => _TempoState();
}

class _TempoState extends State<Tempo> {
  int current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IndexedStack(
            index: current,
            children: [
              Container(
                height: 200,
                width: 200,
                color: Colors.cyanAccent,
                child: Center(
                  child: Text("Name"),
                ),
              ),
              Column(
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    color: Colors.cyanAccent,
                    child: Center(
                      child: Text("Usertype"),
                    ),
                  ),
                ],
              ),
              Container(
                height: 200,
                width: 200,
                color: Colors.cyanAccent,
                child: Center(
                  child: Text("Email"),
                ),
              ),
              Column(
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    color: Colors.cyanAccent,
                    child: Center(
                      child: Text("Password"),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              (current == 0
                  ? SizedBox()
                  : ElevatedButton(
                      onPressed: () {
                        setState(() {
                          current -= 1;
                        });
                      },
                      child: Text("Previous"),
                    )),
              (current < 3
                  ? ElevatedButton(
                      onPressed: () {
                        setState(() {
                          current += 1;
                        });
                      },
                      child: Text("Next"),
                    )
                  : ElevatedButton(
                      onPressed: () {},
                      child: Text("Submit"),
                    ))
            ],
          )
        ],
      ),
    ));
  }
}
