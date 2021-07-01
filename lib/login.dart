import 'package:flutter/material.dart';
import 'package:hello/about.dart';
import 'package:hello/auth/authentication.dart';
import 'package:hello/custom_widgets/anime_button.dart';
import 'package:hello/messaging/messaging_home.dart';
import 'package:hello/signup.dart';

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

  @override
  Widget build(BuildContext context) {
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
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.alternate_email_outlined,
                      color: Colors.black,
                      size: 25,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle: TextStyle(fontSize: 18),
                    hintText: "email",
                    errorStyle: TextStyle(fontSize: 18, color: Colors.red),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    contentPadding: EdgeInsets.all(10)),
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
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "password",
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Colors.black,
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
                  password = newValue;
                }),
              ),
              AnimeButton(
                height: 60,
                width: 100,
                backgroundColor: Colors.amberAccent,
                onPressed: () async {
                  if (_loginKey.currentState.validate()) {
                    print("valid");
                    setState(() {
                      status = "Signing in...";
                    });
                    // Future<bool> status =
                    await _auth.signIn(email, password).then((value) {
                      setState(() {
                        status = value;
                      });
                      if (status == "success") {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    MessagingHome()));
                      }
                    });
                  }
                },
                child: Text(
                  "Login",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ),
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
              Text(
                "New to App??",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AboutPage()));
                },
                child: Text("about"),
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
