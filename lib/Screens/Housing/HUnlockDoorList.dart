import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

class HUnlockDoorList extends StatefulWidget {
  UnlockDoorListState createState() => new UnlockDoorListState();
}

class UnlockDoorListState extends State<HUnlockDoorList> {
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
                  text: 'Done',
                ),
              ],
            ),
            title: Text(
              'Unlock Door',
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
                            .document('UnlockDoor')
                            .collection('UnlockDoor')
                            .where('Status', isEqualTo: 'Pending')
                            .orderBy('Created')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData)
                            return new Center(
                              child: new CircularProgressIndicator(),
                            );
                          return new ListView(shrinkWrap: true, children: <
                              Widget>[
                            new ListView(
                              shrinkWrap: true,
                              children: snapshot.data.documents
                                  .map((DocumentSnapshot document) {
                                return new ExpansionTile(
                                  title: new Text(
                                      'Building: ${document['Building']} Room: ${document['Room']}'),
                                  children: <Widget>[
                                    new Text('Name: ${document['Name']}'),
                                    new Text('Status: ${document['Status']}'),
                                    new Text('Status: ${document['Comment']}'),
                                    new Text(
                                        'Created: ${document['Created'].toString()}'),
                                  ],
                                  trailing: new Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Container(
                                        width: 50.0,
                                        child: new FlatButton(
                                          child: Icon(Icons.recent_actors),
                                          textColor: Colors.blueAccent,
                                          onPressed: () {
                                            _handlePressed(context, document);
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
                        'Done:',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15.0),
                      new StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection('Requests')
                              .document('UnlockDoor')
                              .collection('UnlockDoor')
                              .where('Status', isEqualTo: 'Done')
                              .orderBy('Created')
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
                                            'Building: ${document['Building']} Room: ${document['Room']}'),
                                        children: <Widget>[
                                          new Text('Name: ${document['Name']}'),
                                          new Text(
                                              'Status: ${document['Status']}'),
                                          new Text(
                                              'Status: ${document['Comment']}'),
                                          new Text(
                                              'Created: ${document['Created'].toString()}'),
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

  void _handlePressed(BuildContext context, DocumentSnapshot document) {
    confirmDialog(context).then((bool value) async {
      if (value) {
        Firestore.instance.runTransaction((transaction) async {
          DocumentSnapshot ds = await transaction.get(document.reference);

          await transaction.update(ds.reference, {'Status': 'Done'});

          var token;
          await Firestore.instance
              .collection("Users")
              .document(document['UID'])
              .get()
              .then((data) {
            token = data.data['token'];
          });
          await Firestore.instance.collection("Notifications").add({
            "date": new DateTime.now(),
            "message": "Your Unlock door request is done!",
            "title": "Room is unlocked.",
            "sender": "Housing department",
            "to_token": token,
            "reciever": document['UID']
          });
          _showToast(context, "Request is processed to done successfully!");
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
