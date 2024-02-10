import 'package:flutter/material.dart';

class Styles{
  static ThemeData themeData(BuildContext){
    return ThemeData(
        colorScheme: const ColorScheme.light(
            brightness: Brightness.light,
            primary: Colors.black,
            secondary: Colors.grey,
          tertiary: Colors.white
        )
    );
  }
}