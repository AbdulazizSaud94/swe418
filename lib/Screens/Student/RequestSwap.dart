import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RequestSwap extends StatefulWidget {
  @override
  RequestSwapState createState() => new RequestSwapState();
}

class RequestSwapState extends State<RequestSwap> {
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

  String userEmail;
  var receivedStream;
  var createdStream;
  String uid;
  bool bol = false;
  var stream1;

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) async {
      if (user.uid.isNotEmpty) {
        setState(() {
          bol = true;
          this.uid = user.uid;
          this.userEmail = user.email;
        });
        stream1 = stream1 = Firestore.instance
            .collection('Requests')
            .document('SwapRoom')
            .collection('SwapRoom')
            .where('Sender', isEqualTo: userEmail)
            .snapshots();
      }
    });
    super.initState();
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
                  text: 'Received Requests',
                ),
                Tab(
                  text: 'Sent Requests',
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
              'Swap Requests',
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              //First tab
              Container(
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 30.0),
                    Container(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text('Received Requests',
                          style: TextStyle(
                              fontSize: 22.0,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 15.0),
                    new StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection('Requests')
                            .document('SwapRoom')
                            .collection('SwapRoom')
                            .where('Receiver', isEqualTo: userEmail)
                            .where('ReceiverApproval', isEqualTo: 'Pending')
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
                                            'From: ${document['Sender']}'),
                                        children: <Widget>[
                                          new Text(
                                              'Status: ${document['ReceiverApproval'].toString()}'),
                                          new Text(
                                              'Sent: ${document['Sent'].toString()}'),
                                        ],
                                        trailing: new Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            new Container(
                                              width: 50.0,
                                              child: new FlatButton(
                                                child: Icon(FontAwesomeIcons
                                                    .solidCheckSquare),
                                                textColor: Colors.grey,
                                                onPressed: () {_handlePressedApprove(context, document);},
                                              ),
                                            ),
                                            new Container(
                                              width: 50.0,
                                              child: new FlatButton(
                                                child: Icon(FontAwesomeIcons
                                                    .solidWindowClose),
                                                textColor: Colors.grey,
                                                onPressed: () {_handlePressedReject(context, document);},
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ]);
                          } else {
                            return new Text('  You Have No Requests');
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
                    Container(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text('Sent Requests',
                          style: TextStyle(
                              fontSize: 22.0,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 15.0),
                    new StreamBuilder<QuerySnapshot>(
                        stream: stream1,
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
                                          'To: ${document['Receiver']}'),
                                      children: <Widget>[
                                        new Text(
                                            'Status: ${document['ReceiverApproval'].toString()}'),
                                        new Text(
                                            'Sent: ${document['Sent'].toString()}'),
                                      ],
                                      trailing: new Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Container(
                                            width: 50.0,
                                            child: new FlatButton(
                                              child: Icon(Icons.delete_forever),
                                              textColor: Colors.grey,
                                              onPressed: () {_handlePressedDelete(context, document);},
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
                            return new Text('  You Have No Requests');
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

  void _handlePressedDelete(BuildContext context, DocumentSnapshot document) {
    confirmDialogDelete(context).then((bool value) async {
      if (value) {
        Firestore.instance.runTransaction((transaction) async {
          DocumentSnapshot ds = await transaction.get(document.reference);
          await transaction.delete(ds.reference);

          _showToast(context, "Request is deleted!");
        });
      }
    });
  }

  void _handlePressedReject(BuildContext context, DocumentSnapshot document) {
    confirmDialogReject(context).then((bool value) async {
      if (value) {
        Firestore.instance.runTransaction((transaction) async {
          DocumentSnapshot ds = await transaction.get(document.reference);
          await transaction.update(ds.reference, {'ReceiverApproval': 'Rejected'});
          _showToast(context, "Request is rejected!");
        });
      }
    });
  }

  void _handlePressedApprove(BuildContext context, DocumentSnapshot document) {
    confirmDialogApprove(context).then((bool value) async {
      if (value) {
        Firestore.instance.runTransaction((transaction) async {
          DocumentSnapshot ds = await transaction.get(document.reference);
          await transaction.update(ds.reference, {'ReceiverApproval': 'Approved'});
          _showToast(context, "Request is Approved!");
        });
      }
    });
  }
}

Future<bool> confirmDialogDelete(BuildContext context) {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text("Delete request?"),
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

Future<bool> confirmDialogReject(BuildContext context) {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text("Reject request?"),
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

Future<bool> confirmDialogApprove(BuildContext context) {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text("Approve request?"),
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