import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RequestSwap extends StatefulWidget {
  @override
  RequestSwapState createState() => new RequestSwapState();
}

class RequestSwapState extends State<RequestSwap> {
  String userEmail;
  var receivedStream;
  var createdStream;
  bool bol = false;

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) async {
      this.userEmail = user.email;
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
                  text: 'Sent Requests',
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
              //First tab
              Container(
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 30.0),
                    Container(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text('Received Requests',
                          style: TextStyle(
                              fontSize: 22.0,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 15.0),
                    new StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection('Requests')
                            .document('SwapRoom')
                            .collection('SwapRoom')
                            .where('Receiver', isEqualTo: userEmail)
                            .where('ReceiverApproval', isEqualTo: 'Pending')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData)
                            return new Center(
                              child: new CircularProgressIndicator(),
                            );
                          if (snapshot.data.documents.isNotEmpty) {
                            return new ListView(
                                shrinkWrap: true,
                                children: <Widget>[
                                  new ListView(
                                    shrinkWrap: true,
                                    children: snapshot.data.documents
                                        .map((DocumentSnapshot document) {
                                      return new ExpansionTile(
                                        title: new Text(
                                            'From: ${document['Sender']}'),
                                        children: <Widget>[
                                          new Text(
                                              'Status: ${document['ReceiverApproval'].toString()}'),
                                          new Text(
                                              'Sent: ${document['Sent'].toString()}'),
                                        ],
                                        trailing: new Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            new Container(
                                              width: 50.0,
                                              child: new FlatButton(
                                                child: Icon(FontAwesomeIcons
                                                    .solidCheckSquare),
                                                textColor: Colors.grey,
                                                onPressed: () {},
                                              ),
                                            ),
                                            new Container(
                                              width: 50.0,
                                              child: new FlatButton(
                                                child: Icon(FontAwesomeIcons
                                                    .solidWindowClose),
                                                textColor: Colors.grey,
                                                onPressed: () {},
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ]);
                          } else {
                            return new Text('You Have No Requests');
                          }
                        }),
                  ],
                ),
              ),
              //Second tab
              Container(
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 30.0),
                    Container(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text('Sent Requests',
                          style: TextStyle(
                              fontSize: 22.0,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 15.0),
                    new StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection('Requests')
                            .document('SwapRoom')
                            .collection('SwapRoom')
                            .where('Sender', isEqualTo: userEmail)
                            .where('ReceiverApproval', isEqualTo: 'Pending')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData)
                            return new Center(
                              child: new CircularProgressIndicator(),
                            );
                          if (snapshot.data.documents.isNotEmpty) {
                            return new ListView(
                                shrinkWrap: true,
                                children: <Widget>[
                                  new ListView(
                                    shrinkWrap: true,
                                    children: snapshot.data.documents
                                        .map((DocumentSnapshot document) {
                                      return new ExpansionTile(
                                        title: new Text(
                                            'To: ${document['Receiver']}'),
                                        children: <Widget>[
                                          new Text(
                                              'Status: ${document['ReceiverApproval'].toString()}'),
                                          new Text(
                                              'Sent: ${document['Sent'].toString()}'),
                                        ],
                                        trailing: new Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            new Container(
                                              width: 50.0,
                                              child: new FlatButton(
                                                child: Icon(FontAwesomeIcons
                                                    .solidWindowClose),
                                                textColor: Colors.grey,
                                                onPressed: () {},
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ]);
                          } else {
                            return new Text('You Have No Requests');
                          }
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
