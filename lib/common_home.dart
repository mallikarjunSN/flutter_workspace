import 'package:flutter/material.dart';
import 'package:hello/custom_widgets/cool_color.dart';
import 'package:hello/login.dart';
import 'package:hello/signup.dart';

class CommonHome extends StatefulWidget {
  const CommonHome({key}) : super(key: key);

  @override
  _CommonHomeState createState() => _CommonHomeState();
}

class _CommonHomeState extends State<CommonHome> {
  double height, width;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "welcome to",
                  style: TextStyle(),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "VOX",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: CoolColor.primaryColor),
                ),
                SizedBox(
                    height: width * 0.45,
                    width: width * 0.45,
                    child: Image.asset("assets/logo.png")),
                Text(
                  "Our App has two parts",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  height: height * 0.23,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Learning Hub for people with dyslexia",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        indent: width * 0.25,
                        endIndent: width * 0.25,
                        color: Colors.black,
                      ),
                      Text(
                        "This part of our App provides Reading and Typing exercises, which can help people with dyslexia to practice reading and recognizing the letters and words.",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 1.5,
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  height: height * 0.15,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Messaging Platform",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        indent: width * 0.25,
                        endIndent: width * 0.25,
                        color: Colors.black,
                      ),
                      Text(
                        "This part of our app is a messaging platform with interactive accessibility features",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 1.5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                      child: Text("Login"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Signup()));
                      },
                      child: Text("Signup"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
