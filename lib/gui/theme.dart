import 'package:flutter/material.dart';

ThemeData get lightTheme {
  return ThemeData(
    primarySwatch: Colors.blue,
    cardColor: Colors.white70,
    cardTheme: CardTheme(
        // color: Colors.pink[100],
        // shadowColor: Colors.black54,
        ),
    // accentIconTheme: IconThemeData(
    //   color: Colors.deepPurple[200],
    // ),
    // primaryIconTheme: IconThemeData(
    //   color: Colors.deepPurple[200],
    // ),
    textTheme: TextTheme(
      // bodyText2: TextStyle(color: Colors.pink),
      subtitle1: TextStyle(color: Colors.pink[400]),
      caption: TextStyle(color: Colors.black38), // card 内起效，用于图片的辅助性文字
    ),
    iconTheme: IconThemeData(
      color: Colors.deepPurple[200],
    ),
  );
}
