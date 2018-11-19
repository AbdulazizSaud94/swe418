import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationPage extends StatelessWidget {
  Stream<QuerySnapshot> notifyList() {
    var user, token;
    FirebaseAuth.instance.currentUser().then((_user) {
      user = _user.uid;
    });
    Firestore.instance.collection("Users").document(user).get().then((data) {
      token = data.data['token'];
    });
    return Firestore.instance
        .collection('Notifications')
        .orderBy('date', descending: true)
        .where('to_token', isEqualTo: token)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Notifications'),
      ),
      body: new StreamBuilder<QuerySnapshot>(
        stream: notifyList(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return new Text('Loading...');
          return new ListView(
            shrinkWrap: true,
            children: snapshot.data.documents.map((DocumentSnapshot document) {
              return new ListTile(
                title: new Text("From:" +
                    document['sender'] +
                    ": " +
                    document['title'].toString()),
                subtitle: new Text(document['message'] +
                    " Date: " +
                    document['date'].toString()),
                trailing: new Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Container(
                      width: 50.0,
                      child: new FlatButton(
                        child: Icon(Icons.notifications),
                        textColor: Colors.blueAccent,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                onTap: () {}, // view user detaild TODO
              );
            }).toList(),
          );
        },
      ),
    );
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
