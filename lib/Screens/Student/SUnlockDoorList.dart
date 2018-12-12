import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SUnlockDoorList extends StatefulWidget {
  UnlockDoorListState createState() => new UnlockDoorListState();
}

class UnlockDoorListState extends State<SUnlockDoorList> {
  String uid;
  final formKey = GlobalKey<FormState>();
  String building;
  String room;
  String name;
  String email;
  DateTime created;
  String comment;
  bool bol = false;
  var stream;

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) async {
      this.uid = user.uid;
      await Firestore.instance
          .collection('Users')
          .document(uid)
          .get()
          .then((data) {
        if (data.exists) {
          setState(() {
            this.name = data['Name'];
            this.email = data['Email'];
            this.building = data['Building'];
            this.room = data['Room'];
            this.bol = true;
          });
        }
      });
    });
    stream = Firestore.instance
        .collection('Requests')
        .document('UnlockDoor')
        .collection('UnlockDoor')
        .where('UID', isEqualTo: uid)
        .where('Status', isEqualTo: 'Pending')
        .snapshots();
    super.initState();
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

  void validateAndSubmit() async {
    created = DateTime.now();
    formKey.currentState.save();
    await Firestore.instance
        .collection('Requests')
        .document('UnlockDoor')
        .collection('UnlockDoor')
        .document()
        .setData({
      'Email': email,
      'Name': name,
      'Building': building,
      'Room': room,
      'Comment': comment,
      'Status': "Pending",
      'Created': created,
      'Housing_Emp': "",
      'UID': uid
    });

    _showToast(context, "Request is generated successfully!");
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  text: 'My Requests',
                ),
                Tab(
                  text: 'Create New Request',
                ),
              ],
            ),
            title: Text(
              'Unlock Door',
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
                      child: Text('My Requests',
                          style: TextStyle(
                              fontSize: 22.0,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 15.0),
                    new StreamBuilder<QuerySnapshot>(
                        stream: stream,
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
                                          'Comment: ${document['Comment'].toString()}'),
                                      subtitle: new Text(
                                          'Created: ${document['Created'].toString()}\n Status: ${document['Status']}'),
                                      onTap: () {}, // view user detaild TODO
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
              //Second tab
              Container(
                padding: EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
                child: new Form(
                  key: formKey,
                  child: new ListView(
                    children: <Widget>[
                      Text(
                        'Requesting Door Unlock:',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Text(
                        "Building: ${building} Room: ${room}",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      TextFormField(
                        maxLength: 200,
                        onSaved: (value) => comment = value,
                        decoration: InputDecoration(
                          labelText: 'Comment (optional)',
                          labelStyle: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                      ),
                      Container(
                        height: 50.0,
                        width: 130.0,
                        child: RaisedButton(
                            color: Colors.green,
                            splashColor: Colors.blueGrey,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0)),
                            child: Text(
                              'Send Request',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              _handlePressed(context);
                            }),
                      ),
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

  void _handlePressed(BuildContext context) {
    confirmDialog(context).then((bool value) async {
      if (value) {
        validateAndSubmit();
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
          title: new Text("Send Request?"),
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
