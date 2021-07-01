import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hello/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hello/messaging/messaging_home.dart';
import 'package:hello/provider_manager/user_manager.dart';
import 'package:provider/provider.dart';

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

  User user;
  @override
  Widget build(BuildContext context) {
    user = _auth.currentUser;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MessagingUserManager>(
          create: (_) => MessagingUserManager(),
          lazy: true,
        )
      ],
      child: MaterialApp(
        home: (user == null ? Login() : MessagingHome()),
        theme: ThemeData.light(),
        debugShowCheckedModeBanner: false,
        // showSemanticsDebugger: true,
      ),
    );
  }
}
