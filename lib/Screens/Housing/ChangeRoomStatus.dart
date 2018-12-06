import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'HViewRoom.dart';

class ChangeRoomStatus extends StatefulWidget {
  @override
  ChangeRoomStatusState createState() => new ChangeRoomStatusState();
  final String buildingNumber;
  final String roomNumber;
  final String stuIDA;
  final String stuIdB;

  //constructor
  ChangeRoomStatus({
    this.buildingNumber,
    this.roomNumber,
    this.stuIDA,
    this.stuIdB,
  });
}

class ChangeRoomStatusState extends State<ChangeRoomStatus> {
  String roomStatus = 'Full';

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) async {
      await Firestore.instance
          .collection('Room')
          .document('${widget.buildingNumber}-${widget.roomNumber}')
          .get()
          .then((data) {
        if (data.exists) {
          setState(() {
            roomStatus = data['room_status'];
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
            'Status of B${widget.buildingNumber}-R${widget.roomNumber}'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Row(
            children: <Widget>[
              Text(
                ' Current Status: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                roomStatus,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            ' Change status to: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Row(
            children: <Widget>[
              Radio(
                value: 'Unavailable',
                groupValue: roomStatus,
                onChanged: (String val) => valueRadio(val),
              ),
              Radio(
                value: 'Full',
                groupValue: roomStatus,
                onChanged:  (String val) => valueRadio(val),
              ),
              Radio(
                value: 'Vacant',
                groupValue: roomStatus,
                onChanged:  (String val) => valueRadio(val),
              ),
              Radio(
                value: 'Single',
                groupValue: roomStatus,
                onChanged:  (String val) => valueRadio(val),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void valueRadio(String val) {
    setState(() {
      if (val == 'Unavailable') {
        roomStatus = 'Unavailable';
      }
      else if (val == 'Full') {
        roomStatus = 'Full';
      }
      else if (val == 'Vacant') {
        roomStatus = 'Vacant';
      }
      else {
        roomStatus = 'Single';
      }

    });
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
}
