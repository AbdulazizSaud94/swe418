import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'EditProfile.dart';
import 'SetProfilePicture.dart';
import 'ViewRoom.dart';

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
  String avatar;
  String room;
  String building;
  bool bol = false;

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) async {
      this.uid = user.uid;
      await Firestore.instance
          .collection('Users')
          .document(uid)
          .get()
          .then((data) {
        if (data.exists) {
          setState(() {
            this.name = data['Name'];
            this.email = data['Email'];
            this.major = data['Major'];
            this.city = data['City'];
            this.graduationTerm = data['GraduationTerm'];
            this.smoking = data['Smoking'];
            this.mobile = data['Mobile'];
            this.intrestsHobbies = data['IntrestsHobbies'];
            this.dislike = data['Dislikes'];
            this.avatar = data['Avatar'];
            this.building = data['Building'];
            this.room = data['Room'];
            this.bol = true;
          });
        }
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
      ),
      body: new FutureBuilder<DocumentSnapshot>(
          future: Firestore.instance.collection('Users').document(uid).get(),
          builder: (context, snapshot) {
            if (!bol) {
              return new Center(
                child: new CircularProgressIndicator(),
              );
            }
            return new ListView(children: <Widget>[
              new Stack(
                children: <Widget>[
                  Positioned(
                      child: ButtonBar(
                    children: <Widget>[],
                  )),
                  Positioned(
                    top: 70.0,
                    left: 310.0,
                    child: Container(
                      height: 50.0,
                      width: 50.0,
                      child: RaisedButton(
                          child: Icon(
                            FontAwesomeIcons.solidImages,
                            color: Colors.white,
                          ),
                          color: Colors.grey.withOpacity(0.78),
                          elevation: 1.0,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(75.0)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SetProfilePicture(
                                      name: name,
                                      uid: uid,
                                      email: email,
                                      avatar: avatar,
                                    ),
                              ),
                            );
                          }),
                    ),
                  ),
                  Positioned(
                    top: 15.0,
                    left: 310.0,
                    child: Container(
                      height: 50.0,
                      width: 50.0,
                      child: RaisedButton(
                          child: Icon(
                            FontAwesomeIcons.userEdit,
                            color: Colors.white,
                          ),
                          color: Colors.grey.withOpacity(0.78),
                          elevation: 1.0,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(75.0)),
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
                    width: 320.0,
                    left: 25.0,
                    top: MediaQuery.of(context).size.height / 40,
                    child: Column(
                      children: <Widget>[
                        new Center(
                          child: Container(
                            width: 150.0,
                            height: 150.0,
                            decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                image: DecorationImage(
                                    image: NetworkImage(avatar),
                                    fit: BoxFit.cover),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(75.0)),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 20.0, color: Colors.black)
                                ]),
                          ),
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
                                  Container(
                                      padding: EdgeInsets.only(top: 30.0)),
                                  Text(
                                    'City:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                  Text(
                                    '  $city',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.only(top: 75.0)),
                                  Text(
                                    'Graduation Term:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                  Text(
                                    '  $graduationTerm',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.only(top: 120.0)),
                                  Text(
                                    'Smoking:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                  Text(
                                    '  $smoking',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.only(top: 170.0)),
                                  Text(
                                    'Major:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                  Text(
                                    '  $major',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.only(top: 220.0)),
                                  Text(
                                    'Mobile:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                  FlatButton(
                                    onPressed: _LaunchMobile,
                                    child: Text(
                                      '$mobile',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: new TextStyle(
                                        color: Colors.black54,
                                        fontSize: 16.0,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.only(top: 270.0)),
                                  Text(
                                    'Room:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      if (room == '0') {
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ViewRoom(
                                                  buildingNumber: '$building',
                                                  roomNumber: '$room',
                                                ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Text(
                                      (room == '0'
                                          ? 'No room'
                                          : '$building-$room'),
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
//                                    Text(
//                                      '$building-$room',
//                                      textAlign: TextAlign.center,
//                                      overflow: TextOverflow.ellipsis,
//                                      style: new TextStyle(
//                                        color: Colors.black54,
//                                        fontSize: 16.0,
//                                        decoration: TextDecoration.underline,
//                                      ),
//                                    ),
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
                      padding: EdgeInsets.only(top: 490.0),
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
            ]);
          }),
      //Drawer
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new Container(
              height: 120.0,
              child: new DrawerHeader(
                padding: new EdgeInsets.all(0.0),
                decoration: new BoxDecoration(
                  color: Colors.white30,
                ),
                child: new Center(
                  child: Image.asset('assets/images/System Logo.png',width: 260,),
                ),
              ),
            ),
            new Divider(),
            new ListTile(
                leading: new Icon(FontAwesomeIcons.bullhorn),
                title: new Text('Announcements List'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed('/AnnouncementsList');
                }),
            new ListTile(
                leading: new Icon(FontAwesomeIcons.externalLinkAlt),
                title: new Text('Requests Page'),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/RequestsPage');
                }),
            new ListTile(
                leading: new Icon(Icons.library_books),
                title: new Text('Your Contract'),
                onTap: () {
                  Navigator.of(context).pushNamed('/RoomContract');
                }),
            new ListTile(
                leading: new Icon(FontAwesomeIcons.building),
                title: new Text('Building List'),
                onTap: () {
                  Navigator.of(context).pushNamed('/BuildingList');
                }),
            new ListTile(
                leading: new Icon(FontAwesomeIcons.mailchimp),
                title: new Text('Posts'),
                onTap: () {
                  Navigator.of(context).pushNamed('/PostPage');
                }),
            new ListTile(
                leading: new Icon(Icons.pan_tool),
                title: new Text('Complaints'),
                onTap: () {
                  Navigator.of(context).pushNamed('/Complaints');
                }),
            new ListTile(
                leading: new Icon(FontAwesomeIcons.signOutAlt),
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
    String url = 'mailto:' +
        email +
        '?subject=From%20STUHousing_&body=From%20STUHousing';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _LaunchMobile() async {
    String url = 'tel:' + mobile;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
