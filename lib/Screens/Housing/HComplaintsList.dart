import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class HComplaintsList extends StatefulWidget {
  HComplaintsListState createState() => new HComplaintsListState();
}

class HComplaintsListState extends State<HComplaintsList> {
  String uid;
  QuerySnapshot doc;


  void _showToast(BuildContext context, String message) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content:  Text(message),
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) async {
      this.uid = user.uid;
      doc = await Firestore.instance
          .collection('Requests')
          .document('Complaints')
          .collection('Complaints')
          .where("Status", isEqualTo: 'Pending')
          .getDocuments();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Complaint Requests'),
      ),
      body: new StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('Requests')
              .document('Complaints')
              .collection('Complaints')
              .where('Status', isEqualTo: 'Pending')
              .orderBy('Created')
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
                  return new ExpansionTile(
                    title: new Text('Title: ${document['Title']} \nStatus: ${document['Status']}'),
                    children: <Widget>[
                      new Text('Details: ${document['Details']}', textAlign: TextAlign.left),
                      new Text('Status: ${document['Status']}'),
                      new Text('Created: ${document['Created'].toString()}'),
                      //new Text('Bulding: ${document['Building']}, Floor: ${document['Floor']}, Room: ${document['Room']}'),
                    ],
                    trailing: new Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Container(
                          width: 50.0,
                          child: new FlatButton(
                            child: Icon(FontAwesomeIcons.angleDoubleRight),
                            onPressed: () {
                              _handlePressed(context, document);
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
    );
  }
  
  _launchURL(BuildContext context, DocumentSnapshot document) async {
  var url = await FirebaseStorage.instance.ref().child("Complaints/${document.data['Attachment']}").getDownloadURL();

  if (await canLaunch(url)) {
    await launch(url,forceWebView: true);
  } else {
    throw 'Could not launch $url';
  }
 }

  void _handlePressed(BuildContext context, DocumentSnapshot document) {
    confirmDialog(context).then((bool value) async {
      if (value) {
        Firestore.instance.runTransaction((transaction) async {
          DocumentSnapshot ds = await transaction.get(document.reference);
          var token ;
          await Firestore.instance.collection("Users").document(document['UID'])
              .get().then((data){
            token = data.data['token'];
          });
          await Firestore.instance.collection("Notifications").add({
            "date": new DateTime.now(),
            "message":"Your complaint is processed!",
            "title": "Complaint .",
            "sender": "Housing department",
            "to_token": token,
            "reciever": document['UID']
          });

          await transaction.update(ds.reference, {'Status' : 'Done'});
          _showToast(context, "Data is change to done successfully!");
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
