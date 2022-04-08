import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData gelap = ThemeData(
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: Colors.lightBlue,
    primarySwatch: Colors.lightBlue);
ThemeData terang = ThemeData(
  fontFamily: 'Poppins',
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  primarySwatch: Colors.blue,
);

class ThemeNotifier extends ChangeNotifier {
  final String key = "theme";
  late bool temaGelap;

  bool get darkTheme => temaGelap;

  ThemeNotifier() {
    temaGelap = true;
    ambilData();
  }

  ubahTema() {
    temaGelap = !temaGelap;
    ubahData();
    notifyListeners();
  }

  ambilData() async {
    final prefs = await SharedPreferences.getInstance();
    temaGelap = prefs.getBool(key) ?? true;
    notifyListeners();
  }

  ubahData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, true);
    prefs.setBool(key, temaGelap);
  }
}
