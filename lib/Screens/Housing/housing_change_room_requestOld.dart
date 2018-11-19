import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

class HousingChangeRoomPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Change Room Requests'),
      ),
      body: new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('Requests')
            .document("ChangeRoom")
            .collection("ChangeRoom")
            .where("partner_approve", isEqualTo: "approve")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return new Text('Loading...');
          return new ListView(
            shrinkWrap: true,
            children: snapshot.data.documents.map((DocumentSnapshot document) {
              return new ListTile(
                title: new Text("ID_1: " +
                    document['requester_id'] +
                    " ID_2: " +
                    document['partner_id']),
                subtitle: new Text("Request to go to: " +
                    document['requested_building'] +
                    " / " +
                    document['requested_room']),
                trailing: new Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Container(
                      width: 50.0,
                      child: new FlatButton(
                        child: Icon(Icons.delete_forever),
                        textColor: Colors.blueAccent,
                        onPressed: () async {
                          var token, token2;
                          await Firestore.instance
                              .collection("Users")
                              .document(document['requester_id'])
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
                          await Firestore.instance
                              .collection("Notifications")
                              .add({
                            "date": new DateTime.now(),
                            "message": "Your request is refused!",
                            "title": "Request to change room",
                            "sender": "Housing department",
                            "to_token": token,
                            "reciever": document['requester_id']
                          });
                          _showToast(
                              context, "Request is refused successfully!");
                          await Firestore.instance
                              .collection("Notifications")
                              .add({
                            "date": new DateTime.now(),
                            "message": "Your request is refused!",
                            "title": "Request to change room",
                            "sender": "Housing department",
                            "to_token": token2,
                            "reciever": document['partner_id']
                          });
                          document.reference
                              .updateData({"request_status": "refused"});
                        },
                      ),
                    ),
                    new Container(
                      width: 50.0,
                      alignment: Alignment(0.0, 0.0),
                      child: new FlatButton(
                        child: Icon(Icons.add),
                        textColor: Colors.blueAccent,
                        onPressed: () async {
                          var token, token2;
                          await Firestore.instance
                              .collection("Users")
                              .document(document['requester_id'])
                              .get()
                              .then((data) {
                            token = data.data['token'];
                          });
                          await Firestore.instance
                              .collection("Users")
                              .document(document['partner_id'])
                              .get()
                              .then((data) {
                            token2 = data.data['token'];
                          });
                          _showToast(context, "Request is approved");
                          await Firestore.instance
                              .collection("Notifications")
                              .add({
                            "date": new DateTime.now(),
                            "message": "Your request is approved!",
                            "title": "Request to change room",
                            "sender": "Housing department",
                            "to_token": token,
                            "reciever": document['requester_id']
                          });
                          await Firestore.instance
                              .collection("Notifications")
                              .add({
                            "date": new DateTime.now(),
                            "message": "Your request is approved!",
                            "title": "Request to change room",
                            "sender": "Housing department",
                            "to_token": token2,
                            "reciever": document['partner_id']
                          });
                          document.reference
                              .updateData({"request_status": "approve"});
                        },
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
