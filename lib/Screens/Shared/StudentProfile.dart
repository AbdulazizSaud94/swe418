import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class StudentProfile extends StatefulWidget {
  @override
  StudentProfileState createState() => new StudentProfileState();

  final String stuId;
  //constructor
  StudentProfile({
    this.stuId,
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
  bool bol = false;

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) async {
      await Firestore.instance
          .collection('Users')
          .document(widget.stuId)
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
          future: Firestore.instance.collection('Users').document(widget.stuId).get(),
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
                                    image: NetworkImage(
                                        'https://i.stack.imgur.com/l60Hf.png'),
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
                    top: 326.0,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 5.0),
                          child: Stack(
                            children: <Widget>[

                              Row(
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.only(top: 60.0)),
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
                                      padding: EdgeInsets.only(top: 200.0)),
                                  Text(
                                    'Mobile Number:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                  Text(
                                    '  $mobile',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.only(top: 240.0)),
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
                          ExpansionTile(
                            title: Text(
                              'Options',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            children: <Widget>[
                              Container(
                                height: 30.0,
                                width: 98.0,
                                child: RaisedButton.icon(
                                    onPressed: null, icon: Icon(Icons.swap_horiz, color: Colors.white,
                                ), label: Text('Swap', style: TextStyle(color: Colors.white),),
                                ),
                              ),
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
    String url = 'mailto:' + email + '?subject=News&body=New%20plugin';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}


