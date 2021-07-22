import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hello/auth/authentication.dart';
import 'package:hello/common/report_issues.dart';
import 'package:hello/common/update_profile.dart';
import 'package:hello/common_home.dart';
import 'package:hello/custom_widgets/cool_color.dart';
import 'package:hello/custom_widgets/toggle_botton.dart';
import 'package:hello/login.dart';
import 'package:hello/provider_manager/theme_manager.dart';
import 'package:hello/services/string_service.dart';
import 'package:hello/services/user_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatefulWidget {
  MyDrawer({
    key,
    @required this.current,
  }) : super(key: key);

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

  void showAbout() {
    showAboutDialog(
      context: context,
      applicationName: "Vox",
      applicationIcon: Icon(FontAwesomeIcons.vectorSquare),
      applicationLegalese: "Free and open source",
      applicationVersion: "1.0.0",
    );
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
                              MaterialPageRoute(builder: (context) => CommonHome()))
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
      elevation: 20,
      child: ListView(
        addRepaintBoundaries: true,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: CoolColor.primaryColor),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "VOX",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/user.png",
                        height: 70,
                        width: 70,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      FutureBuilder<String>(
                        future: UserService()
                            .getUserName(FirebaseAuth.instance.currentUser.uid),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            String fullName = snapshot.data;
                            return Text(
                              StringService().capitalize(fullName),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 21),
                            );
                          } else
                            return CircularProgressIndicator();
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.userAlt),
            title: Text("Update Profile"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UpdateProfile()));
            },
          ),
          // ListTile(
          //   leading: FaIcon(FontAwesomeIcons.cog),
          //   title: Text("Settings"),
          // ),
          ListTile(
            leading: Icon(Icons.brightness_2),
            title: Row(
              children: [
                Text("Dark Theme"),
                SizedBox(
                  width: 50,
                ),
                Consumer<ThemeManager>(
                  builder: (context, ThemeManager themeManager, child) =>
                      ToggleButton(
                    status: themeManager.theme,
                    onPressed: () {
                      themeManager.setTheme(!(themeManager.theme));
                    },
                  ),
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
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FeedbackAndIssues()));
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.android),
            title: Text("Version 1.0.0"),
            onTap: () {
              Navigator.pop(context);
              showAbout();
            },
          ),
          // ListTile(
          //   leading: Icon(FontAwesomeIcons.googlePlay),
          //   title: Text("Rate this app on play store"),
          // ),
        ],
      ),
    );
  }
}
