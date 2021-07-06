import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hello/custom_widgets/my_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

//hello world is always cool => www ~~>
class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  Animation<double> clockAnim;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    clockAnim = Tween<double>(begin: 0, end: pi).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.linear));

    _animationController.forward();

    print(pi);
    _animationController.repeat();
    super.initState();
  }

  Future<void> setTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDark", false);
    setState(() {
      isDark = false;
    });
  }

  bool isDark = false;

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
        setState(() {
          isDark = false;
        });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    getTheme();
    return MaterialApp(
      theme: (isDark ? ThemeData.dark() : ThemeData.light()),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  const Home({key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class NewPage extends StatefulWidget {
  const NewPage({key}) : super(key: key);

  @override
  _NewPageState createState() => _NewPageState();
}

bool status = false;

class _NewPageState extends State<NewPage> {
  bool status = false;

  double sliderValue = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
    );
  }
}

class _HomeState extends State<Home> {
  static int currentIdx = 2;

  List<Widget> screens = [
    // DyslexiaHome(),
    // AssesmentsHome(),
    NewPage(),
  ];

  double currentSize = 30;

  double twoPi = 2 * pi;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          elevation: 30,
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(
              "https://cdn1-www.superherohype.com/assets/uploads/2013/11/batmane3-1.jpg",
              fit: BoxFit.cover,
              height: 100,
              width: 100,
            ),
          ),
        ),
      ),
      drawer: MyDrawer(
        current: context.widget.toString(),
      ),
      body: Center(
        child: screens.elementAt(currentIdx),
      ),
    );
  }
}
