import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'HSwapList.dart';

class HSwapRequest extends StatefulWidget {
  @override
  HSwapRequestState createState() => new HSwapRequestState();

  final String senderID;
  final String receiverID;
  final String senderPosition;
  final String receiverPosition;
  final String senderBuilding;
  final String senderRoom;
  final String receiverBuilding;
  final String receiverRoom;
  final String senderEmail;
  final String receiverEmail;
  final String sent;
  final String requestID;

  //constructor
  HSwapRequest({
    this.senderID,
    this.receiverID,
    this.senderPosition,
    this.receiverPosition,
    this.senderBuilding,
    this.senderRoom,
    this.receiverBuilding,
    this.receiverRoom,
    this.senderEmail,
    this.receiverEmail,
    this.sent,
    this.requestID,
  });
}

class HSwapRequestState extends State<HSwapRequest> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Approve Swap'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 15.0,
          ),
          Text(
            ' Swap Students: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Text(
            ' Student: ${widget.senderEmail}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          Text(
            ' From room ${widget.senderBuilding}-${widget.senderRoom} to room ${widget.receiverBuilding}-${widget.receiverRoom}',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Text(
            ' Student: ${widget.receiverEmail}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          Text(
            ' From room ${widget.receiverBuilding}-${widget.receiverRoom} to room ${widget.senderBuilding}-${widget.senderRoom}',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          SizedBox(
            height: 50.0,
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
                  'Confirm Swap',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {

                   if(widget.senderPosition=='A'){
                     Firestore.instance
                         .collection('Room')
                         .document('${widget.senderBuilding}-${widget.senderRoom}')
                         .updateData({'Email1': widget.receiverEmail, 'UID1': widget.receiverID,});

                     Firestore.instance
                         .collection('Users')
                         .document(widget.receiverID)
                         .updateData({'Building': widget.senderBuilding, 'Room': widget.senderRoom, 'Position': 'A'});
                   }
                   else{
                     Firestore.instance
                         .collection('Room')
                         .document('${widget.senderBuilding}-${widget.senderRoom}')
                         .updateData({'Email2': widget.receiverEmail, 'UID2': widget.receiverID,});

                     Firestore.instance
                         .collection('Users')
                         .document(widget.receiverID)
                         .updateData({'Building': widget.senderBuilding, 'Room': widget.senderRoom, 'Position': 'B'});
                   }

                   if(widget.receiverPosition=='A'){
                     Firestore.instance
                         .collection('Room')
                         .document('${widget.receiverBuilding}-${widget.receiverRoom}')
                         .updateData({'Email1': widget.senderEmail, 'UID1': widget.senderID,});

                     Firestore.instance
                         .collection('Users')
                         .document(widget.senderID)
                         .updateData({'Building': widget.receiverBuilding, 'Room': widget.receiverRoom, 'Position': 'A'});
                   }
                   else{
                     Firestore.instance
                         .collection('Room')
                         .document('${widget.receiverBuilding}-${widget.receiverRoom}')
                         .updateData({'Email2': widget.senderEmail, 'UID2': widget.senderID,});

                     Firestore.instance
                         .collection('Users')
                         .document(widget.senderID)
                         .updateData({'Building': widget.receiverBuilding, 'Room': widget.receiverRoom, 'Position': 'B'});
                   }


                   Firestore.instance
                       .collection('Requests')
                       .document("SwapRoom")
                       .collection("SwapRoom").document(widget.requestID).updateData({'HousingApproval': 'Approved',});
                   Navigator.of(context).pushReplacementNamed('/HSwapList');
                }),
          ),
        ],
      ),
    );
  }
}
