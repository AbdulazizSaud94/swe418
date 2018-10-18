import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'EditProfile.dart';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => new ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  String name;
  String email;
  String uid;
  String city;
  String mobile;
  String intrestsHobbies;
  String dislike;
  String graduationTerm;
  String major;
  String smoking;

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
        this.major = data['Major'];
        this.city = data['City'];
        this.graduationTerm = data['GraduationTerm'];
        this.smoking = data['Smoking'];
        this.mobile = data['Mobile'];
        this.intrestsHobbies = data['IntrestsHobbies'];
        this.dislike = data['Dislikes'];
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfile(
                              name: name,
                              city: city,
                              major: major,
                              graduationTerm: graduationTerm,
                              smoking: smoking,
                              mobile: mobile,
                              intrestsHobbies: intrestsHobbies,
                              dislike: dislike,
                              uid: uid,
                              email: email,
                            ),
                      ),
                    );
                  }),
            ),
          ),
          Positioned(
            width: 350.0,
            left: 25.0,
            top: MediaQuery.of(context).size.height / 40,
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
                FlatButton(
                  onPressed: _launchEmail,
                  child: Text(
                    '$email',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: new TextStyle(
                      color: Colors.black54,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                SizedBox(height: 25.0),
              ],
            ),
          ),
          Positioned(
            top: 310.0,
            child: Container(
              color: Colors.black.withOpacity(0.58),
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              width: 225.0,
              height: 2.0,
            ),
          ),
          Positioned(
            top: 300.0,
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
            top: 338.0,
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
                            '  $city',
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
                            '  $graduationTerm',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(padding: EdgeInsets.only(top: 150.0)),
                          Text(
                            'Smoking:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0),
                          ),
                          Text(
                            '  $smoking',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(padding: EdgeInsets.only(top: 200.0)),
                          Text(
                            'Mobile Number:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0),
                          ),
                          Text(
                            '  $mobile',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(padding: EdgeInsets.only(top: 240.0)),
                          Text(
                            'Major:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0),
                          ),
                          Text(
                            '  $major',
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
              padding: EdgeInsets.only(top: 470.0),
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
                      Text('$intrestsHobbies'),
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
                      Text('$dislike'),
                    ],
                  ),
                ],
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

            new ListTile(
                leading: new Icon(Icons.exit_to_app),
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
        ),
      ),
    );
  }

  _launchEmail() async {
    String url = 'mailto:' + email + '?subject=News&body=New%20plugin';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
