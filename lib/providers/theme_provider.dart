import 'package:chatly/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(lightTheme);

  bool get isDarkMode => state == darkTheme;

  void toggleTheme() {
    state = isDarkMode ? lightTheme : darkTheme;
  }

  void setTheme(ThemeData theme) {
    state = theme;
  }
}
