import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class RequestSwap extends StatefulWidget {
  @override
  RequestSwapState createState() => new RequestSwapState();
}

class RequestSwapState extends State<RequestSwap> {

  String uid;
  var receivedStream;
  var createdStream;
  bool bol = false;



  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) async {
      this.uid = user.uid;
      if (user.uid.isNotEmpty) {
        setState(() {
          bol = true;
          this.uid = user.uid;
        });
        receivedStream = receivedStream = Firestore.instance
            .collection('Requests')
            .document('SwapRoom')
            .collection('SwapRoom')
            .where('Receiver', isEqualTo: uid)
            .where('Status', isEqualTo: 'Pending')
            .snapshots();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  text: 'Received Requests',
                ),
                Tab(
                  text: 'Created Requests',
                ),
              ],
            ),
            leading: new IconButton(
              icon: new Icon(
                Icons.arrow_back,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Swap Requests',
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              Container(
                child: Text('1'),
              ),
              Container(
                child: Text('2'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
