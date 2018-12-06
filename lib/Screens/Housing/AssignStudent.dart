import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssignStudent extends StatefulWidget {
  @override
  AssignStudentState createState() => new AssignStudentState();
  final String buildingNumber;
  final String roomNumber;
  final String stuIDA;
  final String stuIdB;
  final String emailA;
  final String emailb;

  //constructor
  AssignStudent({
    this.buildingNumber,
    this.roomNumber,
    this.stuIDA,
    this.stuIdB,
    this.emailA,
    this.emailb,
  });
}

class AssignStudentState extends State<AssignStudent> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
            'Assgin to B${widget.buildingNumber}-R${widget.roomNumber}'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[],
      ),
    );
  }
}
