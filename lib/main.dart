import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hello/dyslexia/dyslexia_home.dart';
import 'package:hello/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hello/messaging/messaging_home.dart';
import 'package:hello/services/user_service.dart';
import 'package:hello/verify_email.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  // MessagingUser mUser;

  @override
  void initState() {
    // if (FirebaseAuth.instance.currentUser != null) {
    //   UserService()
    //       .getMessagingUserByEmail(FirebaseAuth.instance.currentUser.email)
    //       .then((value) {
    //     mUser = value;
    //   });
    // }
    getTheme();
    super.initState();
  }

  bool isDark = false;

  Future<void> setTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDark", false);
    setState(() {
      isDark = false;
    });
  }

  Future<void> getTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var status;
    try {
      status = prefs.getBool("isDark");
      if (status != null) {
        setState(() {
          isDark = status;
        });
      } else {
        setTheme();
      }
    } catch (e) {}
  }

  bool isMessagingUser;
  Widget getHome() {
    if (FirebaseAuth.instance.currentUser == null) {
      return Login();
    } else if ((FirebaseAuth.instance.currentUser.emailVerified)) {
      return VerifyEmail();
    } else
      return FutureBuilder<bool>(
        future: UserService().getUsertype(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bool isMessagingUser = snapshot.data;
            return (isMessagingUser ? MessagingHome() : DyslexiaHome());
          } else if (snapshot.hasError) {
            return Text("Some Error");
          } else
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.home,
                      size: 100,
                      color: Colors.amberAccent,
                    ),
                    Text("Loading Your Home.."),
                    CircularProgressIndicator()
                  ],
                ),
              ),
            );
        },
      );
  }

  User user;
  @override
  Widget build(BuildContext context) {
    user = _auth.currentUser;
    return MaterialApp(
      home: getHome(),
      theme: (isDark ? ThemeData.dark() : ThemeData.light()),
      debugShowCheckedModeBanner: false,
      // showSemanticsDebugger: true,
    );
  }
}
