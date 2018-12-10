import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'AssignKey.dart';

class HKeyList extends StatefulWidget {
  @override
  HKeyListState createState() => new HKeyListState();
}

class HKeyListState extends State<HKeyList> {
  final formKey = GlobalKey<FormState>();
  String secuirtyName;
  String details;
  String building;
  String floor;
  String room;
  DateTime created;
  String uid;
  QuerySnapshot doc;
  String role;

//  @override
//  void initState() {
//    FirebaseAuth.instance.currentUser().then((FirebaseUser user) async {
//      this.uid = user.uid;
//      doc = await Firestore.instance
//          .collection('Building')
//          .where("Key_H", isEqualTo: "Room")
//          .getDocuments();
//    });
//
//    // FirebaseAuth.instance.currentUser().then((FirebaseUser user) async {
//    //   this.uid = user.uid;
//    //   await Firestore.instance
//    //       .collection('Users')
//    //       .where("Role", isEqualTo: 'Security')
//    //       .then((data) {
//    //     this.secuirtyName = data['Name'];
//    //     });
//    // });
//    super.initState();
//  }

  void validateAndSubmit() async {
    created = DateTime.now();
    formKey.currentState.save();
    await Firestore.instance.collection('Keys').document().setData({
      'Created': created,
      'Holder': uid,
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  text: 'Not with housing',
                ),
                Tab(
                  text: 'With housing',
                ),
              ],
            ),
            leading: new IconButton(
              icon: new Icon(
                Icons.arrow_back,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Master Keys',
            ),
            centerTitle: true,
          ),
          body: TabBarView(
            children: [
              //First tab
              Container(
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 30.0),
                    Text(
                      ' Keys not held by housing:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    new StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection('Building')
                            .where('key_holder', isEqualTo: "Not Housing")
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData)
                            return new Center(
                              child: new CircularProgressIndicator(),
                            );
                          if (snapshot.data.documents.isNotEmpty) {
                            return new ListView(
                              shrinkWrap: true,
                              children: <Widget>[
                                new ListView(
                                  shrinkWrap: true,
                                  children: snapshot.data.documents
                                      .map((DocumentSnapshot document) {
                                    return new ExpansionTile(
                                      title: new Text(
                                        'Building: ${document['building_number']}',
                                      ),
                                      children: <Widget>[
                                        new FlatButton(
                                          onPressed: () async {
                                            String url = 'mailto:' +
                                                document['holder_email'] +
                                                '?subject=From%20STUHousing_&body=From%20STUHousing';
                                            if (await canLaunch(url)) {
                                              await launch(url);
                                            } else {
                                              throw 'Could not launch $url';
                                            }
                                          },
                                          child: Text(
                                            'Holder email: ' +
                                                document['holder_email'],
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: new TextStyle(
                                              color: Colors.black54,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                        new FlatButton(
                                          onPressed: () async {
                                            String url = 'tel:' +
                                                document['holder_mobile'];
                                            if (await canLaunch(url)) {
                                              await launch(url);
                                            } else {
                                              throw 'Could not launch $url';
                                            }
                                          },
                                          child: Text(
                                            'Holder mobile: ' +
                                                document['holder_mobile'],
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: new TextStyle(
                                              color: Colors.black54,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 25,
                                          width: 120,
                                          child: RaisedButton(
                                            onPressed: () {
                                              retrieveHandlePressed(
                                                  context, document);
                                            },
                                            child: Text(
                                              'Retrieve key',
                                              style: TextStyle(
                                                  color: Colors.black87),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                      ],
                                    );
//                                  } else {
//                                    return new Text(
//                                        '  All keys are held by housing.');
//                                  }
                                  }).toList(),
                                ),
                              ],
                            );
                          } else {
                            return new Text('  All keys are held by housing.');
                          }
                        }),
                  ],
                ),
              ),
              //Second tab
              Container(
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 30.0),
                    Text(
                      ' Keys held by housing:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    new StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection('Building')
                            .where('key_holder', isEqualTo: "Housing")
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData)
                            return new Center(
                              child: new CircularProgressIndicator(),
                            );
                          if (snapshot.data.documents.isNotEmpty) {
                            return new ListView(
                              shrinkWrap: true,
                              children: <Widget>[
                                new ListView(
                                  shrinkWrap: true,
                                  children: snapshot.data.documents
                                      .map((DocumentSnapshot document) {
                                    return new ListTile(
                                      title: new Text(
                                          'Building number: ${document['building_number']}'),
                                      trailing: new Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Container(
                                            width: 50.0,
                                            child: new FlatButton(
                                              child: Icon(
                                                FontAwesomeIcons.userPlus,
                                                size: 20,
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AssignKey(
                                                          buildingNumber:
                                                              '${document['building_number']}',
                                                          buildingID: document
                                                              .documentID,
                                                        ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            );
                          } else {
                            return new Text('  All keys are not held by housing.');
                          }
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void retrieveHandlePressed(BuildContext context, DocumentSnapshot document) {
    confirmRetrieveDialog(context).then((bool value) async {
      if (value) {
        Firestore.instance.runTransaction((transaction) async {
          DocumentSnapshot ds = await transaction.get(document.reference);

          await transaction.update(ds.reference, {
            'key_holder': 'Housing',
            'holder_email': '0',
            'holder_mobile': '0'
          });
        });
      }
    });
  }
}

Future<bool> confirmRetrieveDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text("Retrieve key?"),
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
