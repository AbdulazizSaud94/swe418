import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

class HousingChangeRoomPage extends StatelessWidget {
  void _showToast(BuildContext context, String message) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Added to favorite'),
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                ),
              ],
            ),
            title: Text(
              'Change Room Requests',
              style: TextStyle(fontWeight: FontWeight.bold),
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
                      child: Text('Pending',
                          style: TextStyle(
                              fontSize: 22.0,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 15.0),
                    new StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection('Requests')
                          .document("ChangeRoom")
                          .collection("ChangeRoom")
                          .where("partner_approve", isEqualTo: "approve")
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) return new Text('Loading...');
                        return new ListView(
                          shrinkWrap: true,
                          children: snapshot.data.documents
                              .map((DocumentSnapshot document) {
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
                                        _showToast(context,
                                            "Request is refused successfully!");
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
                                        document.reference.updateData(
                                            {"request_status": "refused"});
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
                                        _showToast(
                                            context, "Request is approved");
                                        await Firestore.instance
                                            .collection("Notifications")
                                            .add({
                                          "date": new DateTime.now(),
                                          "message":
                                              "Your request is approved!",
                                          "title": "Request to change room",
                                          "sender": "Housing department",
                                          "to_token": token,
                                          "reciever": document['requester_id']
                                        });
                                        await Firestore.instance
                                            .collection("Notifications")
                                            .add({
                                          "date": new DateTime.now(),
                                          "message":
                                              "Your request is approved!",
                                          "title": "Request to change room",
                                          "sender": "Housing department",
                                          "to_token": token2,
                                          "reciever": document['partner_id']
                                        });
                                        document.reference.updateData(
                                            {"request_status": "approve"});
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
                  ],
                ),
              ),
              //Second tab
              Container(
                padding: EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
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
                              .document("ChangeRoom")
                              .collection("ChangeRoom")
                              .where("request_status", isEqualTo: "approve")
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData)
                              return new Center(
                                child: new CircularProgressIndicator(),
                              );
                            return new ListView(
                                shrinkWrap: true,
                                children: <Widget>[
                                  new ListView(
                                    shrinkWrap: true,
                                    children: snapshot.data.documents
                                        .map((DocumentSnapshot document) {
                                      return new ExpansionTile(
                                        title: new Text(
                                            'Requsted Building: ${document['requested_building']}Requested Room: ${document['requested_room']}'),
                                        children: <Widget>[
                                          new Text(
                                              'Student 1: ${document['partner_id']}'),
                                          new Text(
                                              'Student 2: ${document['requester_id']}'),
                                          new Text(
                                              'Status: ${document['request_status']}'),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ]);
                          }),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
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
                              .document("ChangeRoom")
                              .collection("ChangeRoom")
                              .where("request_status", isEqualTo: "refused")
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData)
                              return new Center(
                                child: new CircularProgressIndicator(),
                              );
                            return new ListView(
                                shrinkWrap: true,
                                children: <Widget>[
                                  new ListView(
                                    shrinkWrap: true,
                                    children: snapshot.data.documents
                                        .map((DocumentSnapshot document) {
                                      return new ExpansionTile(
                                        title: new Text(
                                            'Requsted Building: ${document['requested_building']}Requested Room: ${document['requested_room']}'),
                                        children: <Widget>[
                                          new Text(
                                              'Student 1: ${document['partner_id']}'),
                                          new Text(
                                              'Student 2: ${document['requester_id']}'),
                                          new Text(
                                              'Status: ${document['request_status']}'),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ]);
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
}
