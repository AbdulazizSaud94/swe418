import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

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
                    Text(' Keys not held by housing:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),),
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
                          return new ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                              new ListView(
                                shrinkWrap: true,
                                children: snapshot.data.documents
                                    .map((DocumentSnapshot document) {
                                  // return new ListTile(
                                  //   title:
                                  //       new Text('Building/Room: ${document['Name']}'),
                                  //   subtitle: new Text(
                                  //     'Building/Room: ${document['Name']}\n Owner1: ${document['Owner1']}\n Owner2: ${document['Owner2']}'),
                                  //   onTap: () {}, // view user detaild TODO
                                  // );
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
                                          onPressed: () {},
                                          child: Text(
                                            'Retrieve key',
                                            style: TextStyle(
                                                color: Colors.black87),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 15,),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ],
                          );
                        }),
                  ],
                ),
              ),
              //Second tab
              Container(
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 30.0),
                    SizedBox(height: 15.0),
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
                          return new ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                              new ListView(
                                shrinkWrap: true,
                                children: snapshot.data.documents
                                    .map((DocumentSnapshot document) {
                                  // return new ListTile(
                                  //   title:
                                  //       new Text('Building/Room: ${document['Name']}'),
                                  //   subtitle: new Text(
                                  //     'Building/Room: ${document['Name']}\n Owner1: ${document['Owner1']}\n Owner2: ${document['Owner2']}'),
                                  //   onTap: () {}, // view user detaild TODO
                                  // );
                                  return new ExpansionTile(
                                    title: new Text(
                                        'Building number: ${document['building_number']}'),
                                    children: <Widget>[
                                      new Text(
                                          'Holder: ${document['key_holder']}',
                                          textAlign: TextAlign.left),
                                      // new Text('Bulding: ${document['Building']}, Floor: ${document['Floor']}, Room: ${document['Room']}'),
                                    ],
                                    trailing: new Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Container(
                                          width: 50.0,
                                          child: new FlatButton(
                                            child: Icon(Icons.assignment),
                                            onPressed: () {
                                              handlePressed(context, document);
                                            },
                                          ),
                                        ),
                                        new Container(
                                          width: 50.0,
                                          child: new FlatButton(
                                            child: Icon(Icons.person),
                                            onPressed: () {
                                              _handlePressed(context, document);
                                            },
                                          ),
                                        ),
                                        // new DropdownButton<String>(
                                        //   hint: Text(role,
                                        //       style: TextStyle(
                                        //           fontSize: 18.0,
                                        //           fontWeight: FontWeight.bold,
                                        //           color: Colors.black54)),
                                        //   items: <String>['Student', 'Housing', 'Security']
                                        //       .map((String value) {
                                        //     return new DropdownMenuItem<String>(
                                        //       value: value,
                                        //       child: new Text(value),
                                        //     );
                                        //   }).toList(),
                                        //   onChanged: (value) {
                                        //     this.setState(() {
                                        //       Text(value,
                                        //           style: TextStyle(
                                        //               fontSize: 18.0,
                                        //               fontWeight: FontWeight.bold,
                                        //               color: Colors.black54));
                                        //       role = value;
                                        //     });
                                        //   },
                                        // ),
                                        // SizedBox(height: 20.0),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          );
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

  void handlePressed(BuildContext context, DocumentSnapshot document) {
    confirmDialog(context, document).then((bool value) async {
      if (value) {
        Firestore.instance.runTransaction((transaction) async {
          created = DateTime.now();
          DocumentSnapshot ds = await transaction.get(document.reference);
          await transaction
              .update(ds.reference, {'Date': created, 'Holder': "Security"});
        });
      }
    });
  }

  void _handlePressed(BuildContext context, DocumentSnapshot document) {
    _confirmDialog(context, document).then((bool value) async {
      if (value) {
        Firestore.instance.runTransaction((transaction) async {
          created = DateTime.now();
          DocumentSnapshot ds = await transaction.get(document.reference);
          await transaction
              .update(ds.reference, {'Date': created, 'Holder': "Housing"});
        });
      }
    });
  }

//
//  _LaunchMobile() async {
//    String url = 'tel:' + mobile;
//    if (await canLaunch(url)) {
//      await launch(url);
//    } else {
//      throw 'Could not launch $url';
//    }
//  }
//}

  Future<bool> confirmDialog(BuildContext context, DocumentSnapshot document) {
    void _showToast(BuildContext context, String message) {
      final scaffold = Scaffold.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: Text(message),
          action: SnackBarAction(
              label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
        ),
      );
    }

    return showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text(
                "Assign Master Key of Building ${document['Name']} to Security Employee?"),
            actions: <Widget>[
              new FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.of(context).pop(true);
                  _showToast(context, "It is assigned!");
                },
              ),
              new FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop(false);

                  _showToast(context, "No assignment!");
                },
              ),
            ],
          );
        });
  }

  Future<bool> _confirmDialog(BuildContext context, DocumentSnapshot document) {
    void _showToast(BuildContext context, String message) {
      final scaffold = Scaffold.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: Text(message),
          action: SnackBarAction(
              label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
        ),
      );
    }

    return showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text(
                "Assign Master Key of Building ${document['Name']} to Housing Employee?"),
            actions: <Widget>[
              new FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.of(context).pop(true);
                  _showToast(context, "It is assigned!");
                },
              ),
              new FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop(false);
                  _showToast(context, "No assignment!");
                },
              ),
            ],
          );
        });
  }
}
