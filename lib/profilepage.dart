import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => new ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          ClipPath(
            child: Container(color: Colors.lightGreen.withOpacity(0.8)),
            clipper: getClipper(),
          ),
          Positioned(
            width: 350.0,
            left: 25.0,
            top: MediaQuery
                .of(context)
                .size
                .height / 5,
            child: Column(
              children: <Widget>[
                Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      image: DecorationImage(
                          image: NetworkImage('http://i.imgur.com/XyDjKCL.png'),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.all(Radius.circular(75.0)),
                      boxShadow: [
                        BoxShadow(blurRadius: 20.0, color: Colors.black)
                      ]),
                ),
                SizedBox(height: 35.0),
                Text(
                  'Rick sanchez',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
        ],
      ),

      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the Drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView
          (
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <
              Widget>[
            Container(
              height: 70.0,
              child
                  : DrawerHeader(
                child: Text('Drawer Header'
                ),
                decoration: BoxDecoration(
                    color: Colors.
                    white12
                ),
              ),
            ),
            ListTile(
              title
                  : Text('Item 1'),
              onTap:
                  () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              }
              ,
            ),
          ]
          ,
        )
        ,
      )
      ,
    );
  }
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
