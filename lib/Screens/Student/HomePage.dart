import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Dashboard'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text('You are logged in'),
              SizedBox(
                height: 15.0,
              ),
              new OutlineButton(
                borderSide: BorderSide(
                    color: Colors.teal, style: BorderStyle.solid, width: 3.0),
                child: Text('Logout'),
                onPressed: () {
                  FirebaseAuth.instance
                      .signOut()
                      .then((value) {
                        Navigator.of(context).pushReplacementNamed('/LoginPage');
                  })
                      .catchError((e) {
                        print(e);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
