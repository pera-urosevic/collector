import 'package:flutter/material.dart';

ThemeData themeData = ThemeData(
  fontFamily: 'NotoSans',
  brightness: Brightness.dark,
  primaryColor: Colors.deepPurple,
  appBarTheme: AppBarTheme(
    color: Colors.deepPurple.shade600,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.deepPurple.shade600,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.white.withOpacity(0.2),
  ),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Colors.deepPurple.shade600,
  ),
  cardTheme: CardTheme(
    color: Colors.grey.shade800.withOpacity(0.7),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.blue.shade600,
    foregroundColor: Colors.white,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: const OutlineInputBorder(borderSide: BorderSide.none),
    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
    isDense: true,
    filled: true,
    fillColor: Colors.grey.shade800,
    hoverColor: Colors.grey.shade800,
    hintStyle: TextStyle(
      color: Colors.white.withOpacity(0.2),
    ),
  ),
  snackBarTheme: SnackBarThemeData(
    contentTextStyle: const TextStyle(
      color: Colors.white,
    ),
    backgroundColor: Colors.blue.shade600,
  ),
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) return Colors.blue.shade400;
      return Colors.grey.shade700;
    }),
    trackColor: MaterialStateProperty.all(Colors.grey.shade800),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all(Colors.white),
      minimumSize: MaterialStateProperty.all(const Size(40.0, 40.0)),
      backgroundColor: MaterialStateProperty.all(Colors.grey.shade800),
      overlayColor: MaterialStateProperty.all(Colors.grey.shade800),
      textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 16.0)),
    ),
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.blue.shade400,
    selectionColor: Colors.blue.shade400,
    selectionHandleColor: Colors.blue.shade400,
  ),
);
