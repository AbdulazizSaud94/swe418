import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';


String email = 's201235200@kfupm.com';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => new ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  String email = 's201235200@kfupm.com';
  int mobile = 05327655677;

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
              top: MediaQuery.of(context).size.height / 5,
              child: Column(
                children: <Widget>[
                  Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        image: DecorationImage(
                            image:
                                NetworkImage('http://i.imgur.com/XyDjKCL.png'),
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
                  SizedBox(height: 15.0),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 25.0),
                ],
              ),
            ),
            Positioned(
              left: 20.0,
              top: 500.0,
              child: Container(
                height: 45.0,
                width: 114.0,
                child: RaisedButton(
                  child: const Text(
                    'Send Email',
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  color: Colors.blueAccent,
                  elevation: 1.0,
                  splashColor: Colors.blueGrey,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  onPressed: _launchEmail,
                ),
              ),
            ),
          ],
        ),
        //Drawer
        drawer: new Drawer(
            child: new ListView(
          children: <Widget>[
            new Container(
              height: 120.0,
              child: new DrawerHeader(
                padding: new EdgeInsets.all(0.0),
                decoration: new BoxDecoration(
                  color: new Color(0xFFECEFF1),
                ),
                child: new Center(
                  child: new FlutterLogo(
                    colors: Colors.lightGreen,
                    size: 54.0,
                  ),
                ),
              ),
            ),
            new Divider(),
            new ListTile(
                leading: new Icon(Icons.exit_to_app),
                title: new Text('Sign Out'),
                onTap: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    Navigator.of(context).pushReplacementNamed('/loginpage');
                  }).catchError((e) {
                    print(e);
                  });
                }),
          ],
        )));
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

_launchEmail() async {
  const email = 's201235200@kfupm.com';
  const url = 'mailto:' + email + '?subject=News&body=New%20plugin';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
