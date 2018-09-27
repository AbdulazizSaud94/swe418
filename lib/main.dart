import 'package:flutter/material.dart';

//pages
import 'Screens/Auth/LoginPage.dart';
import 'Screens/Student/HomePage.dart';
import 'Screens/Admin/AdminTabs.dart';
import 'Screens/Student/ProfilePage.dart';
import 'Screens/Admin/AddUserPage.dart';
import 'Screens/Admin/UsersList.dart';
import 'Screens/Student/RequestsPage.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: RequestsPage(),
      routes: <String, WidgetBuilder>{
        '/LoginPage': (BuildContext context) => new MyApp(),
        '/AdminTabs': (BuildContext context) => new AdminTabs(),
        '/HomePage' : (BuildContext context) => new HomePage(),
        '/ProfilePage': (BuildContext context) => new ProfilePage(),
        '/AddUserPage': (BuildContext context) => new AddUserPage(),
        '/UsersList': (BuildContext context) => new UsersList(),
        '/RequestsPage': (BuildContext context) => new RequestsPage()
      },
    );
  }
}
