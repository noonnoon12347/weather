import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifler extends Notifier<ThemeMode>{
  @override
  ThemeMode build() => ThemeMode.light;
  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}

final themeNotifierProvider = NotifierProvider<ThemeNotifler, ThemeMode>(() => ThemeNotifler());