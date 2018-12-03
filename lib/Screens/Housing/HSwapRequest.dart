import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HSwapRequest extends StatefulWidget {
  @override
  HSwapRequestState createState() => new HSwapRequestState();
}

class HSwapRequestState extends State<HSwapRequest> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('B'),
        centerTitle: true,
      ),
    );
  }
}
