import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class HComplaint extends StatefulWidget {
  @override
  HComplaintState createState() => new HComplaintState();

  final String senderID;
  final String sent;
  final String complaintID;
  final String details;
  final String title;

  //constructor
  HComplaint({
    this.senderID,
    this.sent,
    this.complaintID,
    this.details,
    this.title,
  });
}

class HComplaintState extends State<HComplaint> {
  final formKey = GlobalKey<FormState>();
  String senderEmail;
  String feedback;
  DateTime resolved = DateTime.now();

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) async {
      await Firestore.instance
          .collection('Users')
          .document(widget.senderID)
          .get()
          .then((data) {
        if (data.exists) {
          setState(() {
            senderEmail = data['Email'];
          });
        }
      });
    });
    super.initState();
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    form.save();
    if (form.validate()) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Complaint feedback'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 30.0,
          ),
          Text(
            ' Title:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          Text(
            ' ${widget.title}',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            ' Details:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          Text(
            ' ${widget.details}',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          Row(
            children: <Widget>[
              Text(
                ' By:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              FlatButton(
                  onPressed: () async {
                    _launchEmail();
                  },
                  child: Text(
                    '$senderEmail',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ))
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Form(
                key: formKey,
                child: Stack(
                  children: <Widget>[
                    TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLength: 250,
                        decoration: InputDecoration(
                          labelText: 'Feedback:',
                          labelStyle: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                        onSaved: (value) => feedback = value,
                        validator: (value) {
                          if (value.isEmpty) {
                            // The form is empty
                            return "Field can\'t be empty";
                          }
                        }),
                  ],
                )),
          ),
          SizedBox(
            height: 35.0,
          ),
          Container(
            height: 45.0,
            padding: EdgeInsets.only(left: 70.0, right: 70.0),
            child: RaisedButton(
                color: Colors.green,
                splashColor: Colors.blueGrey,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0)),
                child: Text(
                  'Send feedback',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  if (validateAndSave()) {
                    confirmDialog(context).then((bool value) async {
                      Firestore.instance.runTransaction((transaction) async {
                        var token;
                        await Firestore.instance
                            .collection("Users")
                            .document(widget.senderID)
                            .get()
                            .then((data) {
                          token = data.data['token'];
                        });
                        await Firestore.instance
                            .collection("Notifications")
                            .add({
                          "date": new DateTime.now(),
                          "message": "Your complaint is processed!",
                          "title": "Complaint .",
                          "sender": "Housing department",
                          "to_token": token,
                          "reciever": widget.senderID,
                        });

                        await Firestore.instance
                            .collection('Requests')
                            .document('Complaints')
                            .collection('Complaints')
                            .document(widget.complaintID)
                            .updateData({
                          'Feedback': feedback,
                          'Resolved': resolved,
                          'Status': 'Done',
                        });
                      });
                      Navigator.pop(context);
                    });
                  }
                }),
          ),
        ],
      ),
    );
  }

  _launchEmail() async {
    String url = 'mailto:' +
        senderEmail +
        '?subject=From%20STUHousing_&body=From%20STUHousing';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

Future<bool> confirmDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text("Resolve complaint??"),
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
