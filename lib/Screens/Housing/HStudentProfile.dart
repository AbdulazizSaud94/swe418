import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'HViewRoom.dart';

class HStudentProfile extends StatefulWidget {
  @override
  HStudentProfileState createState() => new HStudentProfileState();

  final String stuId;
  final String building;
  final String room;

  //constructor
  HStudentProfile({
    this.stuId,
    this.building,
    this.room,
  });
}

class HStudentProfileState extends State<HStudentProfile> {
  String name;
  String email;
  String city;
  String mobile;
  String intrestsHobbies;
  String dislike;
  String graduationTerm;
  String major;
  String smoking;
  String stuBuilding;
  String stuRoom;
  String stuPosition;
  String stuAvatar;
  bool bol = false;
  String userEmail;
  String userRoom;
  String userBuilding;
  String userPosition;
  String userRole;

  DateTime swapCreated;
  String uid;

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) async {
      this.uid = user.uid;
      this.userEmail = user.email;

      await Firestore.instance
          .collection('Users')
          .document(uid)
          .get()
          .then((data) {
        if (data.exists) {
          setState(() {
            this.userBuilding = data['Building'];
            this.userRoom = data['Room'];
            this.userPosition = data['Position'];
            this.userRole = data['Role'];
          });
        }
      });

      await Firestore.instance
          .collection('Users')
          .document(widget.stuId)
          .get()
          .then((data) {
        if (data.exists) {
          setState(() {
            this.name = data['Name'];
            this.email = data['Email'];
            this.mobile = data['Mobile'];
            this.major = data['Major'];
            this.city = data['City'];
            this.graduationTerm = data['GraduationTerm'];
            this.smoking = data['Smoking'];
            this.mobile = data['Mobile'];
            this.intrestsHobbies = data['IntrestsHobbies'];
            this.dislike = data['Dislikes'];
            this.stuBuilding = data['Building'];
            this.stuRoom = data['Room'];
            this.stuPosition = data['Position'];
            this.stuAvatar = data['Avatar'];
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
        backgroundColor: Colors.green,
      ),
      body: new FutureBuilder<DocumentSnapshot>(
          future: Firestore.instance
              .collection('Users')
              .document(widget.stuId)
              .get(),
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
                    width: 350.0,
                    left: 10.0,
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
                                    image: NetworkImage(stuAvatar),
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
                          '$name',
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
                    top: 320.0,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 5.0),
                          child: Stack(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.only(top: 59.0)),
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
                                      padding: EdgeInsets.only(top: 105.0)),
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
                                      padding: EdgeInsets.only(top: 150.0)),
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
                                      padding: EdgeInsets.only(top: 195.0)),
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
                                      padding: EdgeInsets.only(top: 240.0)),
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
                                      padding: EdgeInsets.only(top: 285.0)),
                                  Text(
                                    'Room:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      if (stuRoom == '0') {
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HViewRoom(
                                                  buildingNumber:
                                                      '$stuBuilding',
                                                  roomNumber: '$stuRoom',
                                                ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Text(
                                      (stuRoom == '0'
                                          ? 'No room'
                                          : '$stuBuilding-$stuRoom'),
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
            ]);
          }),
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
}

Future<bool> confirmDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text("Send Request?"),
          actions: <Widget>[
            new FlatButton(
              child: Text("Yes"),
              onPressed: () => Navigator.of(context).pop(true),
            ),
            new FlatButton(
              child: Text("No"),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ],
        );
      });
}
