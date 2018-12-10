import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ViewRoom.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StudentProfile extends StatefulWidget {
  @override
  StudentProfileState createState() => new StudentProfileState();

  final String stuId;
  final String building;
  final String room;
  final String roomStatus;

  //constructor
  StudentProfile({
    this.stuId,
    this.building,
    this.room,
    this.roomStatus,
  });
}

class StudentProfileState extends State<StudentProfile> {
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
                                            builder: (context) => ViewRoom(
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
                          Builder(builder: (BuildContext context) {
                            return ExpansionTile(
                              title: Text(
                                'Options',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 30,
                                    ),
// Swap request
                                    Container(
                                      height: 30.0,
                                      width: 98.0,
                                      child: RaisedButton.icon(
                                        onPressed: () {
                                          if (uid == widget.stuId) {
                                            final snackBar = SnackBar(
                                              content: Text(
                                                'Error, this profile belongs to your account!',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                            );
                                            // Find the Scaffold in the Widget tree and use it to show a SnackBar!
                                            Scaffold.of(context)
                                                .showSnackBar(snackBar);
                                          } else if (userRoom == '0') {
                                            final snackBar = SnackBar(
                                              content: Text(
                                                'Error, you have no room!',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                            );
                                            // Find the Scaffold in the Widget tree and use it to show a SnackBar!
                                            Scaffold.of(context)
                                                .showSnackBar(snackBar);
                                          } else if (widget.roomStatus ==
                                              'Single') {
                                            final snackBar = SnackBar(
                                              content: Text(
                                                'Error, this room status is single!',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                            );
                                            // Find the Scaffold in the Widget tree and use it to show a SnackBar!
                                            Scaffold.of(context)
                                                .showSnackBar(snackBar);
                                          } else {
                                            confirmDialogSwap(context)
                                                .then((bool value) async {
                                              if (value) {
                                                swapCreated = DateTime.now();
                                                await Firestore.instance
                                                    .collection('Requests')
                                                    .document('SwapRoom')
                                                    .collection('SwapRoom')
                                                    .document()
                                                    .setData({
                                                  'Sender': userEmail,
                                                  'Receiver': email,
                                                  'SenderUID': uid,
                                                  'ReceiverUID': widget.stuId,
                                                  'SenderPosition':
                                                      userPosition,
                                                  'ReceiverPosition':
                                                      stuPosition,
                                                  'Sent': swapCreated,
                                                  'ReceiverApproval': 'Pending',
                                                  'HousingApproval': 'Pending',
                                                  'SenderBuilding':
                                                      userBuilding,
                                                  'SenderRoom': userRoom,
                                                  'ReceiverBuilding':
                                                      stuBuilding,
                                                  'ReceiverRoom': stuRoom,
                                                });

                                                final snackBar = SnackBar(
                                                  content: Text(
                                                    'Swap Request Created',
                                                    style: TextStyle(
                                                      fontSize: 17.0,
                                                    ),
                                                  ),
                                                );

                                                // Find the Scaffold in the Widget tree and use it to show a SnackBar!
                                                Scaffold.of(context)
                                                    .showSnackBar(snackBar);
                                              }
                                            });
                                          }
                                        },
                                        icon: Icon(
                                          Icons.swap_horiz,
                                          color: Colors.black54,
                                        ),
                                        label: Text(
                                          'Swap',
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
// Pairing request
                                    Container(
                                      height: 30.0,
                                      width: 98.0,
                                      child: RaisedButton.icon(
                                        onPressed: () {
                                          if (uid == widget.stuId) {
                                            final snackBar = SnackBar(
                                              content: Text(
                                                'Error, this profile belongs to your account!',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                            );
                                            // Find the Scaffold in the Widget tree and use it to show a SnackBar!
                                            Scaffold.of(context)
                                                .showSnackBar(snackBar);
                                          } else if (widget.roomStatus ==
                                              'Full') {
                                            final snackBar = SnackBar(
                                              content: Text(
                                                'Error, this student already has a roommate!',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                            );
                                            // Find the Scaffold in the Widget tree and use it to show a SnackBar!
                                            Scaffold.of(context)
                                                .showSnackBar(snackBar);
                                          } else if (widget.roomStatus ==
                                              'Single') {
                                            final snackBar = SnackBar(
                                              content: Text(
                                                'Error, this room status is single!',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                            );
                                            // Find the Scaffold in the Widget tree and use it to show a SnackBar!
                                            Scaffold.of(context)
                                                .showSnackBar(snackBar);
                                          } else {
                                            confirmDialogPairing(context)
                                                .then((bool value) async {
                                              if (value) {
                                                swapCreated = DateTime.now();
                                                await Firestore.instance
                                                    .collection('Requests')
                                                    .document('Pairing')
                                                    .collection(
                                                        'PairingRequests')
                                                    .document()
                                                    .setData({
                                                  'Sender': userEmail,
                                                  'Receiver': email,
                                                  'SenderUID': uid,
                                                  'ReceiverUID': widget.stuId,
                                                  'SenderPosition':
                                                      userPosition,
                                                  'ReceiverPosition':
                                                      stuPosition,
                                                  'ReceiverApproval': 'Pending',
                                                  'HousingApproval': 'Pending',
                                                  'SenderBuilding':
                                                      userBuilding,
                                                  'SenderRoom': userRoom,
                                                  'ReceiverBuilding':
                                                      stuBuilding,
                                                  'ReceiverRoom': stuRoom,
                                                });

                                                final snackBar = SnackBar(
                                                  content: Text(
                                                    'Pairing Request Created',
                                                    style: TextStyle(
                                                      fontSize: 17.0,
                                                    ),
                                                  ),
                                                );

                                                // Find the Scaffold in the Widget tree and use it to show a SnackBar!
                                                Scaffold.of(context)
                                                    .showSnackBar(snackBar);
                                              }
                                            });
                                          }
                                        },
                                        icon: Icon(
                                          FontAwesomeIcons.handshake,
                                          size: 16,
                                          color: Colors.black54,
                                        ),
                                        label: Text(
                                          'Pairing',
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 14,
                                ),
                              ],
                            );
                          }),
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

Future<bool> confirmDialogSwap(BuildContext context) {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text("Send Swap Request?"),
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
Future<bool> confirmDialogPairing(BuildContext context) {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text("Send Pairing Request?"),
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

