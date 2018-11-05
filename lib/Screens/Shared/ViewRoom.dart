import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewRoom extends StatefulWidget {
  @override
  ViewRoomState createState() => new ViewRoomState();
  final String buildingNumber;
  final String roomNumber;
  //constructor
  ViewRoom({
    this.buildingNumber,
    this.roomNumber,
  });
}

class ViewRoomState extends State<ViewRoom> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('B${widget.buildingNumber} R${widget.roomNumber}'),
        centerTitle: true,
      ),
      body: Container(

      ),
    );
  }
}
