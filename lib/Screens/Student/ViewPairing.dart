import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewPairing extends StatefulWidget {
  ViewPairingState createState() => new ViewPairingState();
}

class ViewPairingState extends State<ViewPairing> {
  String uid;
  
  
  @override
  Widget build(BuildContext context) {
   
  FirebaseAuth.instance.currentUser().then((FirebaseUser user) async {
      uid = user.email;});

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
            if (!snapshot.hasData){
              return new Center(
                child: new CircularProgressIndicator(),
              );
            }
            return new ListView(shrinkWrap: true, children: <Widget>[
              new ListView(
                shrinkWrap: true,
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  return new ListTile(
                    title:
                        new Text('From: ${document['From'].toString()}'),
                   
                 
                  trailing: new Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Container(
                          width: 50.0,
                          child: new FlatButton(
                            child: Icon(Icons.email),
                            textColor: Colors.blueAccent,
                            onPressed: () {
                             _handlePressed(context, document, "email");
                            },
                          ),
                        ),

                        new Container(
                          width: 50.0,
                          child: new FlatButton(
                            child: Icon(Icons.done),
                            textColor: Colors.blueAccent,
                            onPressed: () {
                              _handlePressed(context, document, "send");
                            },
                          ),
                        ),
                       ] ));}).toList(),
              ),
            ]);
          }),
    );
  }

  void _handlePressed(BuildContext context, DocumentSnapshot document, String check) async {
    if(check.contains('email')){
      String url = 'mailto:' + document['From'] + '?subject=Pairing Request ';
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }

    }
    else if (check.contains('send')){
        Firestore.instance.runTransaction((transaction) async {
          DocumentSnapshot ds = await transaction.get(document.reference);
          await transaction.update(ds.reference, {'Status' : 'Waiting For Housing'});
        });
      Firestore.instance.collection('Requests').document('Pairing').collection('HousingPairing').document().setData({'Student1': uid,'Student2': document['From'], 'Status':'Pending'});


    }
   
  }
}


