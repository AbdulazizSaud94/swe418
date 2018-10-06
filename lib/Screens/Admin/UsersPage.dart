import 'package:flutter/material.dart';

class UsersPage extends StatefulWidget {
  @override
  UsersPageState createState() => new UsersPageState();
}

class UsersPageState extends State<UsersPage> {
  String email;
  String name;
  String role;


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: Container(

      ),

    );
  }
}
