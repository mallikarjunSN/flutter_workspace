// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hello/auth.dart';
import 'package:hello/home.dart';
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

  final actionsLandscape = Row(
    children: [
      Builder(
        builder: (context) => ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          child: SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.3,
            child: RaisedButton(
              color: Colors.blue,
              onPressed: () async {
                // setState(() {});
                // validate();
              },
              child: Text(
                "Login",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ),
        ),
      ),
      Text(
        "error",
        style: TextStyle(color: Colors.red),
      ),
      SizedBox(
        width: 60,
      ),
      Text(
        "New to App??",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      SizedBox(
        height: 5,
      ),
      Builder(
        builder: (context) => ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          child: SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.3,
            child: RaisedButton(
              color: Colors.blue,
              onPressed: () {},
              child: Text(
                "Signup",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ),
        ),
      )
    ],
  );

  // final actionsPortrait = ;

  AuthService _auth = AuthService();

  String status = " ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.blue[800],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "welcome to",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "COMRADE App",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Icon(
                FontAwesomeIcons.solidLaugh,
                size: 80,
                color: Colors.yellow[800],
              ),
            ),
            Builder(builder: (context) {
              return Form(
                  key: _loginKey,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.yellow[800],
                                size: 30,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              labelStyle: TextStyle(fontSize: 30),
                              hintText: "email",
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
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
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "password",
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.yellow[800],
                                size: 30,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              labelStyle: TextStyle(fontSize: 30),
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
                        SizedBox(
                          height: 25,
                        ),
                        (MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? Column(
                                children: [
                                  Builder(
                                    builder: (context) => ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                      child: SizedBox(
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: RaisedButton(
                                          color: Colors.blue,
                                          onPressed: () async {
                                            if (_loginKey.currentState
                                                .validate()) {
                                              print("valid");
                                              setState(() {
                                                status = "Signing in...";
                                              });
                                              // Future<bool> status =
                                              await _auth
                                                  .signIn(email, password)
                                                  .then((value) {
                                                setState(() {
                                                  status = value;
                                                });
                                                if (status == "success") {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              DyslexiaHome()));
                                                }
                                              });
                                            }
                                          },
                                          child: Text(
                                            "Login",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  (status == "Signing in..."
                                      ? CircularProgressIndicator(
                                          strokeWidth: 5,
                                          backgroundColor: Colors.white,
                                        )
                                      : Text("")),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    status,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: (status == "success" ||
                                                status == "Signing in..."
                                            ? Colors.white
                                            : Colors.red)),
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Text(
                                    "New to App??",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Builder(
                                    builder: (context) => ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                      child: SizedBox(
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        child: RaisedButton(
                                          color: Colors.blue,
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Signup()));
                                          },
                                          child: Text(
                                            "Signup",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 25),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : actionsLandscape)
                      ],
                    ),
                  ));
            })
          ],
        ),
      ),
    );
  }
}
