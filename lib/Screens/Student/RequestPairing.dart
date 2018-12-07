import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestPairing extends StatefulWidget {
  RequestPairingState createState() => new RequestPairingState();
}

class RequestPairingState extends State<RequestPairing> {
  String uemail,uid,userBuilding, userRoom,userPosition,stuBuilding,stuRoom,stuPosition;

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) async {
      uid=user.uid;
      uemail = user.email;
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
                        .where('Receiver', isEqualTo: uemail)
                        .where('ReceiverApproval', isEqualTo: 'Pending')
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
                                        'From: ${document['Sender']}'),
                                  subtitle: new Text('Building/room: ' +
                                  document['SenderBuilding']+'/'+document['SenderRoom']),
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
        Firestore.instance
          .collection('Users')
          .document(document.documentID)
          .get()
          .then((data) {
        if (data.exists) {
          setState(() {
            this.stuBuilding = data['Building'];
            this.stuRoom = data['Room'];
            this.stuPosition = data['Position'];
          });
        }
      });
    confirmDialog(context).then((bool value) async {
      if (value) {
        FirebaseUser user = await FirebaseAuth.instance.currentUser();
        Firestore.instance
            .collection('Requests')
            .document('Pairing')
            .collection('PairingRequests')
            .document()
            .setData({
        'Sender': uemail,
        'Receiver': document['Email'],
        'SenderUID': uid,
        'ReceiverUID':  document.documentID,
        'SenderPosition': userPosition,
        'ReceiverPosition': stuPosition,

        'ReceiverApproval': 'Pending',
        'HousingApproval': 'Pending',
        'SenderBuilding': userBuilding,
        'SenderRoom': userRoom,
        'ReceiverBuilding': stuBuilding,
        'ReceiverRoom': stuRoom,
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
      String url = 'mailto:' + document['Sender'] + '?subject=Pairing Request ';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } else if (check.contains('send')) { confirmDialog(context).then((bool value) async {
      if (value) {
      Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot ds = await transaction.get(document.reference);
        await transaction
            .update(ds.reference, {'ReceiverApproval': 'Approved'});
      });
       
      _showToast(context, "Request is generated successfully!");
    }});}
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
