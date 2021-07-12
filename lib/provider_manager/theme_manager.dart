import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager extends ChangeNotifier {
  // bool _isDark = false;
  bool isDark = false;
  ThemeManager() {
    getTheme();
  }

  Future<void> setTheme(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDark", value);
    isDark = value;
    notifyListeners();
    print("Theme set to $value");
  }

  bool get theme => isDark;

  Future<bool> getTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool("isDark") ?? false;
    notifyListeners();

    return isDark;
  }
}
