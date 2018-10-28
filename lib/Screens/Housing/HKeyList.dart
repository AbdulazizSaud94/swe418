import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class HKeyList extends StatefulWidget {
  @override
  HKeyListState createState() => new HKeyListState();
}

class HKeyListState extends State<HKeyList> {
  final formKey = GlobalKey<FormState>();
  String title;
  String details;
  String building;
  String floor;
  String room;
  DateTime created;
  String uid;
  QuerySnapshot doc;

  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) async {
      this.uid = user.uid;
      doc = await Firestore.instance
          .collection('Keys')
          .where("Type", isEqualTo: "Room")
          .getDocuments();
    });
    super.initState();
  }

  void validateAndSubmit() async {
    created = DateTime.now();
    formKey.currentState.save();
    await Firestore.instance
        .collection('Keys')
        .document()
        .setData({
      'Created': created,
      'Holder': uid,
    });

    Navigator.of(context).pop();
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
                  text: 'Room Keys',
                ),
                Tab(
                  text: 'Master Keys',
                ),
              ],
            ),
            title: Text(
              'Room Keys',
              
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: TabBarView(
            children: [
              //First tab
              Container(
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 30.0),
                    Container(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text('Room Keys',
                          style: TextStyle(
                              fontSize: 22.0,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 15.0),
                    new StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection('Keys')
                            .where('Type', isEqualTo: "Room")
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData)
                            return new Center(
                              child: new CircularProgressIndicator(),
                            );
                          return new ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                              new ListView(
                                shrinkWrap: true,
                                children: snapshot.data.documents
                                    .map((DocumentSnapshot document) {
                                  // return new ListTile(
                                  //   title:
                                  //       new Text('Building/Room: ${document['Name']}'),
                                  //   subtitle: new Text(
                                  //     'Building/Room: ${document['Name']}\n Owner1: ${document['Owner1']}\n Owner2: ${document['Owner2']}'),
                                  //   onTap: () {}, // view user detaild TODO
                                  // );
                                  return new ExpansionTile(
                                    title: new Text('Building/Room: ${document['Name']}'),
                                    children: <Widget>[
                                      new Text('Owner1: ${document['Owner1']}', textAlign: TextAlign.left),
                                      new Text('Owner2: ${document['Owner2']}', textAlign: TextAlign.left),
                                      // new Text('Created: ${document['Created'].toString()}'),
                                      // new Text('Bulding: ${document['Building']}, Floor: ${document['Floor']}, Room: ${document['Room']}'),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ],
                          );
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
                      child: Text('Master Keys',
                          style: TextStyle(
                              fontSize: 22.0,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 15.0),
                    new StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection('Keys')
                            .where('Type', isEqualTo: "Master")
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData)
                            return new Center(
                              child: new CircularProgressIndicator(),
                            );
                          return new ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                              new ListView(
                                shrinkWrap: true,
                                children: snapshot.data.documents
                                    .map((DocumentSnapshot document) {
                                  // return new ListTile(
                                  //   title:
                                  //       new Text('Building/Room: ${document['Name']}'),
                                  //   subtitle: new Text(
                                  //     'Building/Room: ${document['Name']}\n Owner1: ${document['Owner1']}\n Owner2: ${document['Owner2']}'),
                                  //   onTap: () {}, // view user detaild TODO
                                  // );
                                  return new ExpansionTile(
                                    title: new Text('Building/Room: ${document['Name']}'),
                                    children: <Widget>[
                                      new Text('Holder: ${document['Holder']}', textAlign: TextAlign.left),
                                      new Text('Hold Time: ${document['Created'].toString()}'),
                                      // new Text('Bulding: ${document['Building']}, Floor: ${document['Floor']}, Room: ${document['Room']}'),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ],
                          );
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

  void _handlePressed(BuildContext context) {
    confirmDialog(context).then((bool value) async {
      if (value) {
        validateAndSubmit();
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
          title: new Text("Submit Request?"),
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
