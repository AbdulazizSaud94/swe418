import 'package:flutter/material.dart';
//import 'Screens/Home/MyHomePage.dart';
import 'Screens/Admin/AdminTabs.dart';

//pages
import 'loginpage.dart';
import 'homepage.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      routes: <String, WidgetBuilder>{
        '/loginpage': (BuildContext context) => new MyApp(),
        '/homepage': (BuildContext context) => new HomePage()
      },
    );
  }
}
