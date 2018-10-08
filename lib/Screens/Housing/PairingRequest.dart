import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
            .collection('HousingRequests')
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
                        new Text('Student1: ${document['Student1'].toString()}'),
                   subtitle: new Text('Student2: ${document['Student2'].toString()}'),
                 
                  trailing: new Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Container(
                          width: 50.0,
                          child: new FlatButton(
                            child: Icon(Icons.done),
                            textColor: Colors.blueAccent,
                            onPressed: () {
                             _handlePressed(context, document, "Approve");
                            },
                          ),
                        ),

                        new Container(
                          width: 50.0,
                          child: new FlatButton(
                            child: Icon(Icons.remove),
                            textColor: Colors.blueAccent,
                            onPressed: () {
                              _handlePressed(context, document, "Decline");
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
    
    if(check.contains('Decline')){
    Firestore.instance.runTransaction((transaction) async {
          DocumentSnapshot ds = await transaction.get(document.reference);
          await transaction.update(ds.reference, {'Status' : 'Decline'});
        });

    }
    else if (check.contains('Approve')){
        Firestore.instance.runTransaction((transaction) async {
          DocumentSnapshot ds = await transaction.get(document.reference);
          await transaction.update(ds.reference, {'Status' : 'Approve'});
        });
     
    }
   
  }
}


