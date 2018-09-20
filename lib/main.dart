import 'package:flutter/material.dart';

//pages
import 'Screens/Auth/loginpage.dart';
import 'Screens/Student/homepage.dart';
import 'Screens/Admin/AdminTabs.dart';
import 'Screens/Student/profilepage.dart';

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
        '/AdminTabs': (BuildContext context) => new AdminTabs(),
        '/HomePage' : (BuildContext context) => new HomePage(),
        '/profilepage': (BuildContext context) => new ProfilePage()
      },
    );
  }
}
