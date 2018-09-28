import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

class UnlockDoor extends StatefulWidget {
  UnlockDoorState createState() => new UnlockDoorState();
}

class UnlockDoorState extends State<UnlockDoor> {
  final formKey = GlobalKey<FormState>();
  DateTime created;
  String comment;
  DocumentSnapshot _document;
  String uid;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      Firestore.instance
          .collection("Users")
          .document(user.uid)
          .get()
          .then((data) {
        _document = data;
        uid = user.uid;
      });
    });
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
      'Email': _document.data['Email'],
      'Name': _document.data['Name'],
      'Building': _document.data['Building'],
      'Room': _document.data['Room'],
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
      body: new Container(
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
              // Text(
              //   "building: ${_document.data['Building']}, Room: ${_document.data['Room']}",
              //   style: TextStyle(
              //     fontSize: 15.0,
              //     fontStyle: FontStyle.italic,
              //   ),
              // ),
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
                    child: Text(
                      'Send Request',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    splashColor: Colors.lightGreen,
                    onPressed: () {
                      _handlePressed(context);
                    }),
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
          title: new Text("Send Request"),
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
