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
  String name;
  String email;
  String uid;

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) async {
      this.uid = user.uid;
      await Firestore.instance
          .collection('Users')
          .document(uid)
          .get()
          .then((data) {
        this.name = data['Name'];
        this.email = data['Email'];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            top: 10.0,
            left: 295.0,
            child: Container(
              height: 30.0,
              width: 110.0,
              child: RaisedButton(
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  color: Colors.grey.withOpacity(0.78),
                  elevation: 1.0,
                  splashColor: Colors.blueGrey,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  onPressed: () {}),
            ),
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
                          image: NetworkImage(
                              'https://i.stack.imgur.com/l60Hf.png'),
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
                      fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15.0),
                new Text(
                  '$email',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: new TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 25.0),
              ],
            ),
          ),
          Positioned(
            top: 352.0,
            child: Container(
              color: Colors.black.withOpacity(0.58),
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              width: 225.0,
              height: 2.0,
            ),
          ),
          Positioned(
            top: 342.0,
            child: Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 5.0),
                    child: Text(
                      'Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 380.0,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 5.0),
                  child: Stack(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            'AGE:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0),
                          ),
                          Text(
                            '  23 Years old',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(padding: EdgeInsets.only(top: 60.0)),
                          Text(
                            'City:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0),
                          ),
                          Text(
                            '  Jeddah',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(padding: EdgeInsets.only(top: 105.0)),
                          Text(
                            'Graduation Term:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0),
                          ),
                          Text(
                            '  181',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(

            child: Container(
              padding: EdgeInsets.only(top: 450.0),
              child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                ExpansionTile(
                  title: Text(
                    'Intrests & Hobbies',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: <Widget>[
                    Text('dddcdkovidohiehweh ewfhefwh0dfvbkbovepernowiowih0\nguqwigg8fg8f8f9qwdf87qdw8f7f7dqw8gwdgg0qwd0gwdq90g09hdqw\nwdgiuqg9qwdg98qdwg08dqw0'),
                  ],
                ),
                ExpansionTile(
                  title: Text(
                    'Things I dislike',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: <Widget>[
                    Text('dddcdkovidohiehweh ewfhefwh0dfvbkbovepernowiowih0\nguqwigg8fg8f8f9qwdf87qdw8f7f7dqw8gwdgg0qwd0gwdq90g09hdqw\nwdgiuqg9qwdg98qdwg08dqw0'),
                  ],
                ),
              ],
            ),),
//            child: ListView(
//              shrinkWrap: true,
//              children: <Widget>[
//                Container(
//                  padding: EdgeInsets.only(top: 450.0),
//                  child: Stack(
//                    children: <Widget>[
//                      ExpansionTile(
//                        title: Text(
//                          'Intrestst & Hobbies',
//                          style: TextStyle(
//                            color: Colors.black,
//                            fontSize: 20.0,
//                            fontWeight: FontWeight.bold,
//                          ),
//                        ),
//                        children: <Widget>[
//                          Text('dddcdkovidohiehweh ewfhefwh0dfvbkbovepernowiowih0\nguqwigg8fg8f8f9qwdf87qdw8f7f7dqw8gwdgg0qwd0gwdq90g09hdqw\nwdgiuqg9qwdg98qdwg08dqw0'),
//                        ],
//                      ),
//                      Container(padding: EdgeInsets.only(top: 100.0),
//                        child:
//                        ExpansionTile(
//                          title: Text(
//                            'Things I dislike',
//                            style: TextStyle(
//                              color: Colors.black,
//                              fontSize: 20.0,
//                              fontWeight: FontWeight.bold,
//                            ),
//                          ),
//                          children: <Widget>[
//                            Text('dddcdkovidohiehweh ewfhefwh0dfvbkbovepernowiowih0\nguqwigg8fg8f8f9qwdf87qdw8f7f7dqw8gwdgg0qwd0gwdq90g09hdqw\nwdgiuqg9qwdg98qdwg08dqw0'),
//                          ],
//                        ),
//                      ),
//
//                    ],
//                  ),
//
//                ),
//              ],
//            ),


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
                title: new Text('Requests Page'),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/RequestsPage');
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
        ),
      ),
    );
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
