import 'package:flutter/material.dart';

class ThemeService {
  final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);

  void toggleTheme() {
    themeMode.value =
    themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  void setTheme(ThemeMode mode) {
    themeMode.value = mode;
  }
}