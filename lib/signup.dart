import 'package:date_field/date_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hello/auth.dart';
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
  DateTime dob;
  String error;
  String userType;

  // DatabaseReference _testRef =
  //     FirebaseDatabase.instance.reference().child("test");

  List<String> ddItems = ["Person with Dyslexia", "Differently Abled"];

  AuthService _auth = AuthService();

  String status = " ";

  final _firebaseDatabase = FirebaseDatabase.instance.reference();

  User currentUser;

  Future<void> saveUserData() async {
    await _firebaseDatabase.child(currentUser.uid).set({
      "usertype": userType,
      "fullname": fullName,
      "dob": dob.toIso8601String(),
    });
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Temp(),
        ));
  }

  Future _alert(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Error",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
            content: Text(
              "Both the passwords should be same..!!!",
              textAlign: TextAlign.center,
            ),
            actions: [
              RaisedButton(
                  child: Text("OK"), onPressed: () => Navigator.pop(context))
            ],
          );
        });
  }

  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.blue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 35,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "SIGNUP",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.record_voice_over,
                  size: 50,
                  color: Colors.white,
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Builder(builder: (context) {
              return Form(
                  key: _signupKey,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: Container(
                            alignment: Alignment.center,
                            color: Colors.white,
                            width: double.infinity,
                            child: DropdownButton(
                                icon: Icon(Icons.supervised_user_circle),
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
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        DateField(
                            firstDate: DateTime(1995),
                            // lastDate: DateTime(2021),
                            label: "date of birth",
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.calendar_today,
                                  color: Colors.blue,
                                  size: 30,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle: TextStyle(fontSize: 30),
                                hintText: "Date of birth",
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                contentPadding: EdgeInsets.all(10)),
                            onDateSelected: (date) {
                              setState(() {
                                dob = date;
                              });
                            },
                            selectedDate: (dob == null ? null : dob)),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                FontAwesomeIcons.user,
                                color: Colors.blue,
                                size: 30,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              labelStyle: TextStyle(fontSize: 30),
                              hintText: "Full Name",
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              contentPadding: EdgeInsets.all(10)),
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
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(fontSize: 20),
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
                              return "please enter an email address";
                            }
                            return null;
                          },
                          onChanged: (newValue) => setState(() {
                            email = newValue;
                          }),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          style: TextStyle(fontSize: 20),
                          obscureText: !showPassword,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "password",
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.blue,
                                size: 30,
                              ),
                              suffixIcon: IconButton(
                                  icon: Icon(showPassword
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash),
                                  onPressed: () {
                                    setState(() {
                                      showPassword = !showPassword;
                                    });
                                  }),
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
                          height: 10,
                        ),
                        TextFormField(
                          style: TextStyle(fontSize: 20),
                          obscureText: true,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "confirm password",
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.blue,
                                size: 30,
                              ),
                              suffixIcon: IconButton(
                                  icon: Icon(showPassword
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash),
                                  onPressed: () {
                                    setState(() {
                                      showPassword = !showPassword;
                                    });
                                  }),
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
                            cPassword = newValue;
                          }),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Column(
                          children: [
                            Builder(
                              builder: (context) => ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                child: SizedBox(
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: RaisedButton(
                                    color: Colors.cyan[800],
                                    onPressed: () async {
                                      if (_signupKey.currentState.validate()) {
                                        print("valid");
                                        if (password != cPassword) {
                                          _alert(context);
                                        } else {
                                          setState(() {
                                            status = "Creating account...";
                                          });
                                          await _auth
                                              .signUp(email, password)
                                              .then((value) async {
                                            if (value == "success") {
                                              setState(() {
                                                currentUser = FirebaseAuth
                                                    .instance.currentUser;
                                              });
                                              await saveUserData();
                                            }
                                            setState(() {
                                              status = value;
                                            });
                                          });
                                        }
                                      }
                                    },
                                    child: Text(
                                      "Submit",
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
                            (status == "Creating account..."
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
                                          status == "Creating account..."
                                      ? Colors.white
                                      : Colors.red)),
                            ),
                          ],
                        )
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
