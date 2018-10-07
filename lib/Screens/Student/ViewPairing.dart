import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ViewPairing extends StatefulWidget {
  ViewPairingState createState() => new ViewPairingState();
}

class ViewPairingState extends State<ViewPairing> {
  String uid;
  QuerySnapshot doc;
  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) async {
      this.uid = user.email;
      doc = await Firestore.instance
          .collection('Requests')
          .document('Pairing')
          .collection('PairingRequests')
          .where("To", isEqualTo: uid)
          .where('Status', isEqualTo: 'Pending')
          .getDocuments();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Pairing requests'),
      ),
      body: new StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
             .collection('Requests')
            .document('Pairing')
            .collection('PairingRequests')
             .where('To', isEqualTo: uid)
             .where('Status', isEqualTo: 'Pending')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return new Center(
                child: new CircularProgressIndicator(),
              );
            return new ListView(shrinkWrap: true, children: <Widget>[
              new ListView(
                shrinkWrap: true,
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  return new ListTile(
                    title:
                        new Text('From: ${document['From'].toString()}'),
             // subtitle: new Text('Status: ${document['Status']}'),
                    // trailing: new Row(
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: <Widget>[
                    //     new Container(
                    //       width: 50.0,
                    //       child: new FlatButton(
                    //         child: Icon(Icons.delete_forever),
                    //         textColor: Colors.blueAccent,
                    //         onPressed: () {
                    //           _handlePressed(context, document);
                    //         },
                    //       ),
                    //     ),
                    //     new Container(
                    //       width: 50.0,
                    //       alignment: Alignment(0.0, 0.0),
                    //       child: new FlatButton(
                    //         child: Icon(Icons.edit),
                    //         textColor: Colors.blueAccent,
                    //         onPressed: () {
                    //           Navigator.pop(context);
                    //         },
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    onTap: () {}, // view user detaild TODO
                  );
                }).toList(),
              ),
              // new Container(
              //   height: 50.0,
              //   width: 130.0,
              //   child: RaisedButton(
              //       child: Text(
              //         'Request Unlock Door',
              //         style: TextStyle(
              //           fontSize: 15.0,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //       splashColor: Colors.lightGreen,
              //       onPressed: () {
              //         Navigator.of(context).pushNamed('/UnlockDoor');
              //       }),
              // ),
            ]);
          }),
    );
  }

  void _handlePressed(BuildContext context, DocumentSnapshot document) {
    confirmDialog(context).then((bool value) async {
      if (value) {
        Firestore.instance.runTransaction((transaction) async {
          DocumentSnapshot ds = await transaction.get(document.reference);
          await transaction.delete(ds.reference);
        });
      }
    });
  }
}

Future<bool> confirmDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text("Delete User?"),
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
