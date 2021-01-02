// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hello/auth.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.blue[900],
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              FontAwesomeIcons.userLock,
              size: 60,
              color: Colors.white,
            ),
            SizedBox(
              height: 25,
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
                                color: Colors.blue,
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
                              return "please enter some value";
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
                                color: Colors.blue,
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
                              return "please enter some value";
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
                        // SelectAction()

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
                                              // Future<bool> status =
                                              _auth.signIn(email, password,context);
                                            }
                                          },
                                          child: Text(
                                            "Login",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 25),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Text(
                                    "",
                                    style: TextStyle(color: Colors.red),
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
