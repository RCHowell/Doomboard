import 'package:campus_19/views/problems_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.white, // Color for Android
      statusBarBrightness:
          Brightness.light // Dark == white status bar -- for IOS.
      ));
  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doomboard',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        splashColor: Colors.indigo[200],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ProblemsView(),
    );
  }
}
