import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class SingleRoomRequestList extends StatefulWidget {
  SingleRoomRequestListState createState() => new SingleRoomRequestListState();
}

class SingleRoomRequestListState extends State<SingleRoomRequestList> {
  @override
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  text: 'Pending',
                ),
                Tab(
                  text: 'Approved',
                ),
                Tab(
                  text: 'Declined',
                )
              ],
            ),
            title: Text(
              'Single Room Requests',
              style: TextStyle(fontWeight: FontWeight.bold),
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
                    Container(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text('Pending Requests',
                          style: TextStyle(
                              fontSize: 22.0,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 15.0),
                    new StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection('Requests')
                            .document('SingleRoom')
                            .collection('SingleRoom')
                            .where('Status', isEqualTo: 'Pending')
                            .orderBy('Created')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData)
                            return new Center(
                              child: new CircularProgressIndicator(),
                            );
                          return new ListView(shrinkWrap: true, children: <
                              Widget>[
                            new ListView(
                              shrinkWrap: true,
                              children: snapshot.data.documents
                                  .map((DocumentSnapshot document) {
                                return new ExpansionTile(
                                  title: new Text(
                                      'Request: ${document['Request_Body']}'),
                                  children: <Widget>[
                                    new Text('Status: ${document['Status']}'),
                                    new Text(
                                        'Created: ${document['Created'].toString()}'),
                                  ],
                                  trailing: new Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Container(
                                        width: 50.0,
                                        child: new FlatButton(
                                          child: Icon(Icons.done),
                                          textColor: Colors.blueAccent,
                                          onPressed: () {
                                            _approvePressed(context, document);
                                          },
                                        ),
                                      ),
                                      new Container(
                                        width: 50.0,
                                        child: new FlatButton(
                                          child: Icon(Icons.remove),
                                          textColor: Colors.blueAccent,
                                          onPressed: () {
                                            _declinePressed(context, document);
                                          },
                                        ),
                                      ),
                                      new Container(
                                        width: 50.0,
                                        child: new FlatButton(
                                          child: Icon(Icons.attachment),
                                          textColor: Colors.blueAccent,
                                          onPressed: () {
                                            _launchURL(context, document);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ]);
                        }),
                  ],
                ),
              ),
              //Second tab
              Container(
                padding: EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
                child: new Form(
                  child: new ListView(
                    children: <Widget>[
                      Text(
                        'Done Requsts:',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15.0),
                      new StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection('Requests')
                              .document('SingleRoom')
                              .collection('SingleRoom')
                              .where('Status', isEqualTo: 'Approved')
                              .orderBy('Created')
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
                                      return new ExpansionTile(
                                        title: new Text(
                                            'Request: ${document['Request_Body']}'),
                                        children: <Widget>[
                                          new Text(
                                              'Status: ${document['Status']}'),
                                          new Text(
                                              'Created: ${document['Created'].toString()}'),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ]);
                          }),
                    ],
                  ),
                ),
              ),
              //3rd Tab
              Container(
                padding: EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
                child: new Form(
                  child: new ListView(
                    children: <Widget>[
                      Text(
                        'Done Requsts:',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15.0),
                      new StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection('Requests')
                              .document('SingleRoom')
                              .collection('SingleRoom')
                              .where('Status', isEqualTo: 'Declined')
                              .orderBy('Created')
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
                                      return new ExpansionTile(
                                        title: new Text(
                                            'Request: ${document['Request_Body']}'),
                                        children: <Widget>[
                                          new Text(
                                              'Status: ${document['Status']}'),
                                          new Text(
                                              'Created: ${document['Created'].toString()}'),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ]);
                          }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _approvePressed(BuildContext context, DocumentSnapshot document) {
    confirmDialog1(context).then((bool value) async {
      if (value) {
        Firestore.instance.runTransaction((transaction) async {
          DocumentSnapshot ds = await transaction.get(document.reference);
          await transaction.update(ds.reference, {'Status': 'Approved'});
          var token;
          await Firestore.instance
              .collection("Users")
              .document(document['User_ID'])
              .get()
              .then((data) {
            token = data.data['token'];
          });
          await Firestore.instance
              .collection("Users")
              .document(document['partner_id'])
              .get()
              .then((data) {
            token = data.data['token'];
          });

          await Firestore.instance.collection("Notifications").add({
            "date": new DateTime.now(),
            "message": "Your request is Approved!",
            "title": "Request for single room",
            "sender": "Housing department",
            "to_token": token,
            "reciever": document['requester_id']
          });

          _showToast(context, "Request is approved successfully!");
        });
      }
    });
  }

  void _declinePressed(BuildContext context, DocumentSnapshot document) {
    confirmDialog2(context).then((bool value) async {
      if (value) {
        Firestore.instance.runTransaction((transaction) async {
          DocumentSnapshot ds = await transaction.get(document.reference);
          await transaction.update(ds.reference, {'Status': 'Declined'});
          var token;
          await Firestore.instance
              .collection("Users")
              .document(document['User_ID'])
              .get()
              .then((data) {
            token = data.data['token'];
          });
          await Firestore.instance
              .collection("Users")
              .document(document['partner_id'])
              .get()
              .then((data) {
            token = data.data['token'];
          });
          await Firestore.instance.collection("Notifications").add({
            "date": new DateTime.now(),
            "message": "Your request is declined!",
            "title": "Request for single room",
            "sender": "Housing department",
            "to_token": token,
            "reciever": document['requester_id']
          });
        });
      }
    });
  }

  Future<bool> confirmDialog1(BuildContext context) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text("Approve Request?"),
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

  Future<bool> confirmDialog2(BuildContext context) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text("Decline Request?"),
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

  _launchURL(BuildContext context, DocumentSnapshot document) async {
    var url = await FirebaseStorage.instance
        .ref()
        .child("SingleRoomRequests/${document.data['Attachment']}")
        .getDownloadURL();

    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }
}
