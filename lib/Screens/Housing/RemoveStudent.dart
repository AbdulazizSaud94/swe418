import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'HViewRoom.dart';

class RemoveStudent extends StatefulWidget {
  @override
  RemoveStudentState createState() => new RemoveStudentState();
  final String buildingNumber;
  final String roomNumber;
  final String stuIDA;
  final String stuIdB;
  final String emailA;
  final String emailB;

  //constructor
  RemoveStudent({
    this.buildingNumber,
    this.roomNumber,
    this.stuIDA,
    this.stuIdB,
    this.emailA,
    this.emailB,
  });
}

class RemoveStudentState extends State<RemoveStudent> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
            'Remove From B${widget.buildingNumber}-R${widget.roomNumber}'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Container(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                  title: new Text(
                    'Student A: ${widget.emailA}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  trailing: new Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Container(
                        width: 80.0,
                        child: new FlatButton(
                          child: Icon(
                            FontAwesomeIcons.userSlash,
                            size: 22,
                          ),
                          textColor: Colors.grey,
                          onPressed: () async {
                            if (widget.stuIDA == '0') {
                            } else {
                              confirmDialog(context).then((bool value) async {
                                if (value) {
                                  await Firestore.instance
                                      .collection('Users')
                                      .document(widget.stuIDA)
                                      .updateData({
                                    'Position': '0',
                                    'Building': '0',
                                    'Room': '0',
                                  });
                                  await Firestore.instance
                                      .collection('Room')
                                      .document(
                                          '${widget.buildingNumber}-${widget.roomNumber}')
                                      .updateData({
                                    'Email1': 'empty',
                                    'UID1': '0',
                                    'room_status': 'Vacant',
                                  });
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                            buildingNumber:
                                                widget.buildingNumber,
                                            roomNumber: widget.roomNumber,
                                          ),
                                    ),
                                  );
                                }
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                  title: new Text(
                    'Student B: ${widget.emailB}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  trailing: new Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Container(
                        width: 80.0,
                        child: new FlatButton(
                          child: Icon(
                            FontAwesomeIcons.userSlash,
                            size: 22,
                          ),
                          textColor: Colors.grey,
                          onPressed: () async {
                            if (widget.stuIdB == '0') {
                            } else {
                              confirmDialog(context).then((bool value) async {
                                if (value) {
                                  await Firestore.instance
                                      .collection('Users')
                                      .document(widget.stuIdB)
                                      .updateData({
                                    'Position': '0',
                                    'Building': '0',
                                    'Room': '0',
                                  });
                                  await Firestore.instance
                                      .collection('Room')
                                      .document(
                                          '${widget.buildingNumber}-${widget.roomNumber}')
                                      .updateData({
                                    'Email2': 'empty',
                                    'UID2': '0',
                                    'room_status': 'Vacant',
                                  });
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                            buildingNumber:
                                                widget.buildingNumber,
                                            roomNumber: widget.roomNumber,
                                          ),
                                    ),
                                  );
                                }
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
          title: new Text("Are you sure of removing this student?"),
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
