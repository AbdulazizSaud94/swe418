import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


String name;
String email;

class ProfilePage extends StatefulWidget {

  @override
  ProfilePageState createState() => new ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {


  @override
  Widget build(BuildContext context) {
    name=getdata('name');
    email=getdata('email');
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
            'Profile',
          ),
          backgroundColor: Colors.lightGreen.withOpacity(0.8),
        ),
        body: new Stack(
          children: <Widget>[
            ClipPath(
              child: Container(color: Colors.lightGreen.withOpacity(0.8)),
              clipper: GetClipper(),
            ),
            Positioned(
              width: 350.0,
              left: 25.0,
              top: MediaQuery.of(context).size.height / 13,
              child: Column(
                children: <Widget>[
                  Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        image: DecorationImage(
                            image:
                                NetworkImage('https://i.stack.imgur.com/l60Hf.png'),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.all(Radius.circular(75.0)),
                        boxShadow: [
                          BoxShadow(blurRadius: 20.0, color: Colors.black)
                        ]),
                  ),
                  SizedBox(height: 35.0),
                  new Text(
                    'Hello, $name!',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,

                    style: new TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15.0),
                  new Text(
                    '$email',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: new TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
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
                width: 130.0,
                child: RaisedButton.icon(
                  icon: Icon(FontAwesomeIcons.envelope),
                  label: Text(
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
                leading: new Icon(Icons.receipt),
               title: new Text('Requests Page'),
                onTap: () {
                   Navigator.of(context).pushReplacementNamed('/RequestsPage');
                }),
            new ListTile(
                leading: new Icon(Icons.radio),
                title: new Text('Complaints'),
                onTap: () {
                  Navigator.of(context).pushNamed('/Complaints');
                }),
            new ListTile(
                leading: new Icon(Icons.exit_to_app),
                title: new Text('Sign Out'),
                onTap: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    Navigator.of(context).pushReplacementNamed('/LoginPage');
                  }).catchError((e) {
                    print(e);
                  });
                }),
          ],
        )));
  }
}

class GetClipper extends CustomClipper<Path> {
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
  String url = 'mailto:' + email + '?subject=News&body=New%20plugin';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

 String getdata(String geter) {

  FirebaseAuth.instance.currentUser().then((FirebaseUser user) async{
    Firestore.instance.collection("Users").document(user.uid).get().then((data){
     email=data['Email'];
     name=data['Name'];
    });
  });
   if (geter=='name')
    return name;
    if (geter=='email')
    return email;
   return '0';
}