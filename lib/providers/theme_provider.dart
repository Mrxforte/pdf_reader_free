import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light),
  );

  ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
  );

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme');
    if (theme == 'dark') {
      _themeMode = ThemeMode.dark;
    } else if (theme == 'light') {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  Future<void> setTheme(ThemeMode themeMode) async {
    _themeMode = themeMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', themeMode == ThemeMode.dark ? 'dark' : 
                         themeMode == ThemeMode.light ? 'light' : 'system');
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    setTheme(_themeMode);
  }
}

// Theme provider is locale-agnostic.
