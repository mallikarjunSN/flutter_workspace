import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  final _loginKey = GlobalKey();
  String username;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.blue[900],
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                  child: Icon(
                FontAwesomeIcons.user,
                size: 50,
                color: Colors.white,
              )),
            ),
            Builder(builder: (context) {
              return Form(
                  key: _loginKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        child: Container(
                          // margin: EdgeInsets.only(top: 10),
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 60,
                          padding: EdgeInsets.all(10),
                          color: Colors.white,
                          child: TextFormField(
                            initialValue: "username",
                            decoration: InputDecoration(
                                labelStyle: TextStyle(fontSize: 30),
                                // border: ,
                                icon: Icon(
                                  FontAwesomeIcons.at,
                                  color: Colors.black,
                                ),
                                labelText: "Username",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                contentPadding: EdgeInsets.all(10)),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "please enter some value";
                              }
                              return "";
                            },
                            onSaved: (newValue) => setState(() {
                              username = newValue;
                            }),
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 60,
                          padding: EdgeInsets.all(10),
                          // margin: EdgeInsets.only(top: 10),
                          color: Colors.white,
                          child: TextFormField(
                            obscureText: true,
                            initialValue: "password",
                            decoration: InputDecoration(
                                labelStyle: TextStyle(fontSize: 30),
                                // border: ,
                                icon: Icon(
                                  FontAwesomeIcons.key,
                                  color: Colors.black,
                                ),
                                labelText: "Username",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                contentPadding: EdgeInsets.all(10)),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "please enter some value";
                              }
                              return "";
                            },
                            onSaved: (newValue) => setState(() {
                              username = newValue;
                            }),
                          ),
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {},
                        child: Text("Submit"),
                      )
                    ],
                  ));
            })
          ],
        ),
      ),
    );
  }
}
