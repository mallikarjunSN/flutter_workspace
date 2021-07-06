import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hello/auth/authentication.dart';
import 'package:hello/custom_widgets/toggle_botton.dart';
import 'package:hello/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatefulWidget {
  MyDrawer({key, @required this.current}) : super(key: key);

  final String current;

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool isDark = false;

  @override
  void initState() {
    super.initState();
    getTheme();
  }

  Future<void> setTheme(value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDark", value);
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
        setTheme(false);
      }
    } catch (e) {}
  }

  void logout() {
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Logout of the App??",
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
            content: ButtonBar(
              alignment: MainAxisAlignment.spaceEvenly,
              buttonMinWidth: 100,
              mainAxisSize: MainAxisSize.min,
              buttonTextTheme: ButtonTextTheme.primary,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.amber)),
                    onPressed: () async {
                      await AuthService().signOut().then((value) => (value ==
                              "success"
                          ? Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Login()))
                          : print("some error in logging out")));
                    },
                    child: Text(
                      "Yes",
                      style: TextStyle(fontSize: 18),
                    )),
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("No", style: TextStyle(fontSize: 18))),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    getTheme();
    return Drawer(
      child: ListView(
        addRepaintBoundaries: true,
        children: [
          DrawerHeader(
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Image.network(
                      'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png'),
                ),
                Expanded(
                  flex: 2,
                  child: Icon(
                    Icons.android_outlined,
                    size: 50,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.userAlt),
            title: Text("Update Profile"),
          ),
          ListTile(
            leading: Icon(Icons.speaker_notes),
            title: Text("My Account"),
          ),
          ListTile(
            leading: Icon(Icons.brightness_2),
            title: Row(
              children: [
                Text("Dark Theme"),
                SizedBox(
                  width: 50,
                ),
                ToggleButton(
                  status: isDark,
                  onPressed: () {
                    setState(() {
                      isDark = !isDark;
                      setTheme(isDark);
                    });
                  },
                ),
              ],
            ),
          ),
          ListTile(
            title: Row(
              children: [Text("Logout")],
            ),
            onTap: logout,
            leading: Icon(Icons.logout),
          ),
          Divider(
            color: Colors.black.withOpacity(0.75),
            indent: 10,
            endIndent: 10,
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.envelope),
            title: Text("Feedback/Report issues"),
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.android),
            title: Text("Version 1.0.0"),
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.googlePlay),
            title: Text("Rate this app on play store"),
          ),
        ],
      ),
    );
  }
}
