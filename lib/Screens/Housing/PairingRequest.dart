import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PairingRequest extends StatefulWidget {
  PairingRequestState createState() => new PairingRequestState();
}

class PairingRequestState extends State<PairingRequest> {
  String uid;

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
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) async {
      uid = user.email;
    });
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
              'Pairing Requests',
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
                      child: Text('Pending: ',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,)),
                    ),
                    SizedBox(height: 15.0),
                    new StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection('Requests')
                            .document('Pairing')
                            .collection('HousingPairing')
                            .where('Status', isEqualTo: 'Pending')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return new Center(
                              child: new CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.data.documents.isNotEmpty) {
                            return new ListView(shrinkWrap: true, children: <
                                Widget>[
                              new ListView(
                                shrinkWrap: true,
                                children: snapshot.data.documents
                                    .map((DocumentSnapshot document) {
                                  return new ListTile(
                                      title: new Text(
                                          'Student1: ${document['Student1'].toString()}'),
                                      subtitle: new Text(
                                          'Student2: ${document['Student2'].toString()}'),
                                      trailing: new Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            new Container(
                                              width: 50.0,
                                              child: new FlatButton(
                                                child: Icon(Icons.done),
                                                textColor: Colors.blueAccent,
                                                onPressed: () async {
                                                  _handlePressed(context,
                                                      document, "Approve");
                                                  var token, token2;
                                                  await Firestore.instance
                                                      .collection("Users")
                                                      .document(document[
                                                          'from_user_id'])
                                                      .get()
                                                      .then((data) {
                                                    token = data.data['token'];
                                                  });
                                                  await Firestore.instance
                                                      .collection("Users")
                                                      .document(document[
                                                          'to_user_id'])
                                                      .get()
                                                      .then((data) {
                                                    token2 = data.data['token'];
                                                  });
                                                  await Firestore.instance
                                                      .collection(
                                                          "Notifications")
                                                      .add({
                                                    "date": new DateTime.now(),
                                                    "message":
                                                        "Your request is approved!",
                                                    "title":
                                                        "Request to change room",
                                                    "sender":
                                                        "Housing department",
                                                    "to_token": token,
                                                    "reciever":
                                                        document['from_user_id']
                                                  });

                                                  _showToast(context,
                                                      "Request is approved successfully!");
                                                  await Firestore.instance
                                                      .collection(
                                                          "Notifications")
                                                      .add({
                                                    "date": new DateTime.now(),
                                                    "message":
                                                        "Your request is approved!",
                                                    "title": "Pairing request",
                                                    "sender":
                                                        "Housing department",
                                                    "to_token": token2,
                                                    "reciever":
                                                        document['to_user_id']
                                                  });
                                                },
                                              ),
                                            ),
                                            new Container(
                                              width: 50.0,
                                              child: new FlatButton(
                                                child: Icon(Icons.remove),
                                                textColor: Colors.blueAccent,
                                                onPressed: () async {
                                                  _handlePressed(context,
                                                      document, "Decline");
                                                  var token, token2;
                                                  await Firestore.instance
                                                      .collection("Users")
                                                      .document(document[
                                                          'from_user_id'])
                                                      .get()
                                                      .then((data) {
                                                    token = data.data['token'];
                                                  });
                                                  await Firestore.instance
                                                      .collection("Users")
                                                      .document(document[
                                                          'to_user_id'])
                                                      .get()
                                                      .then((data) {
                                                    token2 = data.data['token'];
                                                  });
                                                  await Firestore.instance
                                                      .collection(
                                                          "Notifications")
                                                      .add({
                                                    "date": new DateTime.now(),
                                                    "message":
                                                        "Your request is declined!",
                                                    "title":
                                                        "Request to change room",
                                                    "sender":
                                                        "Housing department",
                                                    "to_token": token,
                                                    "reciever":
                                                        document['from_user_id']
                                                  });
                                                  await Firestore.instance
                                                      .collection(
                                                          "Notifications")
                                                      .add({
                                                    "date": new DateTime.now(),
                                                    "message":
                                                        "Your request is declined!",
                                                    "title": "Pairing request",
                                                    "sender":
                                                        "Housing department",
                                                    "to_token": token2,
                                                    "reciever":
                                                        document['to_user_id']
                                                  });

                                                  _showToast(context,
                                                      "Request is declined successfully!");
                                                },
                                              ),
                                            ),
                                          ]));
                                }).toList(),
                              ),
                            ]);
                          } else {
                            return new Text('  No Requests Found');
                          }
                        }),
                  ],
                ),
              ),
              //Second tab
              Container(
                padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                child: new Form(
                  child: new ListView(
                    children: <Widget>[
                      Text(
                        'Approved:',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15.0),
                      new StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection('Requests')
                              .document('Pairing')
                              .collection('HousingPairing')
                              .where('Status', isEqualTo: 'Approved')
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
                                              'Student 1: ${document['Student1']} Student 2: ${document['Student2']}'),
                                          children: <Widget>[
                                            new Text(
                                                'Status: ${document['Status']}'),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ]);
                            } else {
                              return new Text('  No Requests Found');
                            }
                          }),
                    ],
                  ),
                ),
              ),
              //3rd tab
              Container(
                padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                child: new Form(
                  child: new ListView(
                    children: <Widget>[
                      Text(
                        'Declined:',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15.0),
                      new StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection('Requests')
                              .document('Pairing')
                              .collection('HousingPairing')
                              .where('Status', isEqualTo: 'Declined')
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
                                              'Student 1: ${document['Student1']} Student 2: ${document['Student2']}'),
                                          children: <Widget>[
                                            new Text(
                                                'Status: ${document['Status']}'),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ]);
                            } else {
                              return new Text('  No Requests Found');
                            }
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

  void _handlePressed(
      BuildContext context, DocumentSnapshot document, String check) async {
    if (check.contains('Decline')) {
      Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot ds = await transaction.get(document.reference);
        await transaction.update(ds.reference, {'Status': 'Decline'});
      });
    } else if (check.contains('Approve')) {
      Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot ds = await transaction.get(document.reference);
        await transaction.update(ds.reference, {'Status': 'Approved'});
      });
    }
  }
}

Future<bool> confirmDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text("Mark This As Done?"),
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
