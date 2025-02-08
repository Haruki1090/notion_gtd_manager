import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// カラーコード
final Color redColor = const Color(0xFFD44C47);
final Color blueColor = const Color(0xFF337EA9);
final Color greenColor = const Color(0xFF448361);
final Color yellowColor = const Color(0xFFCB912F);
final Color orangeColor = const Color(0xFFD9730D);
final Color brownColor = const Color(0xFF9F6B53);
final Color greyColor = const Color(0xFF787774);
final Color purpleColor = const Color(0xFF9065B0);
final Color pinkColor = const Color(0xFFC14C8A);

// Light Theme
final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: blueColor,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: blueColor),
      titleTextStyle: TextStyle(color: blueColor, fontSize: 20),
    ),
    colorScheme: ColorScheme.light(
      primary: blueColor,
      secondary: greenColor,
      error: redColor,
    ));

// Dark Theme
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: blueColor,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
    iconTheme: IconThemeData(color: blueColor),
    titleTextStyle: TextStyle(color: blueColor, fontSize: 20),
  ),
  colorScheme: ColorScheme.dark(
    primary: blueColor,
    secondary: greenColor,
    error: redColor,
  ),
);

// テーマモード管理
final themeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);
