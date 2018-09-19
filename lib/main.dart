import 'package:flutter/material.dart';
//import 'Screens/Home/MyHomePage.dart';
import 'Screens/Admin/AdminTabs.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.blueGrey, backgroundColor: Colors.white
        ),
      debugShowCheckedModeBanner: false,
      home: new AdminTabs(),
    );
  }
}