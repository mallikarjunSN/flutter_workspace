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
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.only(left: 25, right: 25),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.cyan,
              Colors.cyanAccent,
              // Color(0xFF00B7D3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Form(
          key: _loginKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "welcome to",
                style: TextStyle(color: Colors.white),
              ),
              Text(
                "VOX",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 50),
              ),
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
                  // filled: true,
                  // fillColor: Colors.white,
                  hintStyle: TextStyle(fontSize: 18, color: Colors.white),
                  labelStyle: TextStyle(fontSize: 10, color: Colors.white),
                  hintText: "email",
                  errorStyle: TextStyle(fontSize: 16, color: Colors.red),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
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
                    // filled: true,
                    // fillColor: Colors.white,
                    hintStyle: TextStyle(color: Colors.white, fontSize: 18),
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
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    labelStyle: TextStyle(fontSize: 18),
                    errorStyle: TextStyle(fontSize: 16, color: Colors.red),
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
              AnimeButton(
                height: 60,
                width: 100,
                backgroundColor: Colors.amberAccent,
                onPressed: login,
                child: Text(
                  "Login",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ),
              // AnimeButton(
              //     width: width * 0.4,
              //     onPressed: () {},
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: [
              //         SizedBox(
              //             height: 25,
              //             width: 25,
              //             child: Image.network(
              //                 "https://cdn.iconscout.com/icon/free/png-256/google-152-189813.png")),
              //         Text(
              //           "Continue with \nGoogle",
              //           style: TextStyle(
              //             color: Colors.white,
              //           ),
              //           textAlign: TextAlign.center,
              //         ),
              //       ],
              //     )),
              (status == "Signing in..."
                  ? CircularProgressIndicator(
                      strokeWidth: 5,
                      backgroundColor: Colors.white,
                    )
                  : Text("")),
              Text(
                status,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: (status == "success" || status == "Signing in..."
                        ? Colors.white
                        : Colors.red)),
              ),
              AnimeButton(
                backgroundColor: Colors.blue,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Signup()));
                },
                child: Text(
                  "Signup",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ],
          ),
        ),
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
