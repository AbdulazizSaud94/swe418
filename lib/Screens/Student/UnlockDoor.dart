import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

class UnlockDoor extends StatefulWidget {
  UnlockDoorState createState() => new UnlockDoorState();
}

class UnlockDoorState extends State<UnlockDoor> {
  final formKey = GlobalKey<FormState>();
  String building;
  String room;
  String name;
  String email;
  DateTime created;
  String comment;
  String uid;
  bool bol = false;

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
    super.initState();
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
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Unlock Door Request"),
      ),
      body: new FutureBuilder<DocumentSnapshot>(
        future: Firestore.instance.collection('Users').document(uid).get(),
        builder: (context, snapshot) {
          if (!bol) {
            return new Center(
              child: new CircularProgressIndicator(),
            );
          }
          return new Container(
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
                    "building: $building, Room: $room",
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
                        color: Colors.black,
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
          );
        },
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
          title: new Text("Send The Request?"),
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
