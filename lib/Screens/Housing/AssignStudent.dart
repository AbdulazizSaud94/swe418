import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'HViewRoom.dart';

class AssignStudent extends StatefulWidget {
  @override
  AssignStudentState createState() => new AssignStudentState();
  final String buildingNumber;
  final String roomNumber;
  final String stuIDA;
  final String stuIdB;

  //constructor
  AssignStudent({
    this.buildingNumber,
    this.roomNumber,
    this.stuIDA,
    this.stuIdB,
  });
}

class AssignStudentState extends State<AssignStudent> {
  String position;
  String roomStatus = 'Vacant';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
            'Assgin To B${widget.buildingNumber}-R${widget.roomNumber}'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Container(
            child: Text(
              ' Students without a room:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          new StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('Users')
                  .where('Role', isEqualTo: 'Student')
                  .where('Room', isEqualTo: '0')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData)
                  return new Center(
                    child: new CircularProgressIndicator(),
                  );
                if (snapshot.data.documents.isNotEmpty) {
                  return new ListView(shrinkWrap: true, children: <Widget>[
                    ListView(
                      shrinkWrap: true,
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        return new ListTile(
                          title: new Text(
                              'Name: ${document['Name']}\nEmail: ${document['Email']}'),
                          trailing: new Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new Container(
                                width: 50.0,
                                child: new FlatButton(
                                  child: Icon(
                                    FontAwesomeIcons.userPlus,
                                    size: 20,
                                  ),
                                  textColor: Colors.grey,
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
                } else {
                  return new Text('  No Students Found');
                }
              }),
        ],
      ),
    );
  }

  void _handlePressed(BuildContext context, DocumentSnapshot document) {
    confirmDialog(context).then((bool value) async {
      if (value) {
        if (widget.stuIDA == '0') {
          position = 'A';
        } else {
          position = 'B';
        }
        if (widget.stuIDA != '0' || widget.stuIdB != '0') {
          roomStatus = 'Full';
        }

        Firestore.instance.runTransaction((transaction) async {
          DocumentSnapshot ds = await transaction.get(document.reference);
          await transaction.update(
            ds.reference,
            {
              'Building': widget.buildingNumber,
              'Room': widget.roomNumber,
              'Position': position,
            },
          );
          if (position == 'A') {
            await Firestore.instance
                .collection('Room')
                .document('${widget.buildingNumber}-${widget.roomNumber}')
                .updateData({
              'Email1': document['Email'],
              'UID1': document.documentID,
              'room_status': roomStatus,
            });
          } else {
            await Firestore.instance
                .collection('Room')
                .document('${widget.buildingNumber}-${widget.roomNumber}')
                .updateData({
              'Email2': document['Email'],
              'UID2': document.documentID,
              'room_status': roomStatus,
            });
          }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HViewRoom(
                    buildingNumber: widget.buildingNumber,
                    roomNumber: widget.roomNumber,
                  ),
            ),
          );
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
          title: new Text("Confirm assigning student to this room?"),
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
