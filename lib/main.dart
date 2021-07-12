import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hello/dyslexia/dyslexia_home.dart';
import 'package:hello/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hello/messaging/messaging_home.dart';
import 'package:hello/provider_manager/theme_manager.dart';
import 'package:hello/services/user_service.dart';
import 'package:hello/verify_email.dart';
import 'package:provider/provider.dart';
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
    super.initState();
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
    return ChangeNotifierProvider<ThemeManager>(
      create: (_) => ThemeManager(),
      child: Consumer<ThemeManager>(
          builder: (context, ThemeManager themeManager, child) {
        print("in main ${themeManager.theme}");
        return MaterialApp(
          home: getHome(),
          theme: (themeManager.isDark ? ThemeData.dark() : ThemeData.light()),
          // theme: ThemeData.light(),
          debugShowCheckedModeBanner: false,
          // showSemanticsDebugger: true,
        );
      }),
    );
  }
}
