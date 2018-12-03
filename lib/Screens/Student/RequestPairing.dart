import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestPairing extends StatefulWidget {
  RequestPairingState createState() => new RequestPairingState();
}

class RequestPairingState extends State<RequestPairing> {
  String uemail;

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) async {
      uemail = user.email;
    });

    return new Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  text: 'New Request',
                ),
                Tab(
                  text: 'Recived Requests',
                ),
              ],
            ),
            title: Text(
              'Pairing Requests',
            ),
          ),
          body: TabBarView(children: [
            //First tab
            Container(
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 30.0),
                  Container(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text('Available Students',
                        style: TextStyle(
                            fontSize: 22.0,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 15.0),
                  new StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection('Users')
                        .where('Status', isEqualTo: 'single')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) return new Text('Loading...');
                      if (snapshot.data.documents.isNotEmpty) {
                        return new ListView(
                          shrinkWrap: true,
                          children: snapshot.data.documents
                              .map((DocumentSnapshot document) {
                            return new ListTile(
                              title: new Text(document['Name']),
                              subtitle: new Text('Major: ' +
                                  document['Major'] +
                                  '     Status: ' +
                                  document['Status']),
                              trailing: new Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Container(
                                    width: 50.0,
                                    child: new FlatButton(
                                      child: Icon(Icons.check),
                                      textColor: Colors.blueAccent,
                                      onPressed: () {
                                        _handlePressed(context, document);
                                      },
                                    ),
                                  ),
                                  new Container(
                                    width: 50.0,
                                    alignment: Alignment(0.0, 0.0),
                                    child: new FlatButton(
                                      child: Icon(Icons.email),
                                      textColor: Colors.blueAccent,
                                      onPressed: () {
                                        String email = document['Email'];
                                        String url = 'mailto:' +
                                            email +
                                            '?subject=Pairing Request';
                                        if (canLaunch(url) != null) {
                                          launch(url);
                                        } else {
                                          throw 'Could not launch $url';
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      } else {
                        return new Text('  You Have No Requests');
                      }
                    },
                  ),
                ],
              ),
            ),

            Container(
              child: ListView(children: <Widget>[
                SizedBox(height: 30.0),
                Container(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('Request Pairing',
                      style: TextStyle(
                          fontSize: 22.0,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 15.0),
                new StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection('Requests')
                        .document('Pairing')
                        .collection('PairingRequests')
                        .where('To', isEqualTo: uemail)
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
                        return new ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                              new ListView(
                                shrinkWrap: true,
                                children: snapshot.data.documents
                                    .map((DocumentSnapshot document) {
                                  return new ListTile(
                                    title: new Text(
                                        'From: ${document['From'].toString()}'),
                                    trailing: new Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Container(
                                            width: 50.0,
                                            child: new FlatButton(
                                              child: Icon(Icons.email),
                                              textColor: Colors.blueAccent,
                                              onPressed: () {
                                                _handleReceived(
                                                    context, document, "email");
                                              },
                                            ),
                                          ),
                                          new Container(
                                            width: 50.0,
                                            child: new FlatButton(
                                              child: Icon(Icons.done),
                                              textColor: Colors.blueAccent,
                                              onPressed: () {
                                                _handleReceived(
                                                    context, document, "send");
                                              },
                                            ),
                                          ),
                                        ]),
                                  );
                                }).toList(),
                              ),
                            ]);
                      } else {
                        return new Text('  You Have No Requests');
                      }
                    }),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  void _handlePressed(BuildContext context, DocumentSnapshot document) {
    confirmDialog(context).then((bool value) async {
      if (value) {
        FirebaseUser user = await FirebaseAuth.instance.currentUser();
        Firestore.instance
            .collection('Requests')
            .document('Pairing')
            .collection('PairingRequests')
            .document()
            .setData({
          'from_user_id': user.uid,
          'From': user.email,
          'to_user_id': document.documentID,
          'To': document['Email'],
          'Status': 'Pending'
        });
      }
    });
  }

  Future<bool> confirmDialog(BuildContext context) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text("Request Pairing?"),
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

  void _handleReceived(
      BuildContext context, DocumentSnapshot document, String check) async {
    if (check.contains('email')) {
      String url = 'mailto:' + document['From'] + '?subject=Pairing Request ';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } else if (check.contains('send')) {
      Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot ds = await transaction.get(document.reference);
        await transaction
            .update(ds.reference, {'Status': 'Waiting For Housing'});
      });
      Firestore.instance
          .collection('Requests')
          .document('Pairing')
          .collection('HousingPairing')
          .document()
          .setData({
        'Student1': uemail,
        'Student2': document['From'],
        'Status': 'Pending'
      });

      _showToast(context, "Request is generated successfully!");
    }
  }

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
}
