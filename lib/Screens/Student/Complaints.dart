import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class Complaints extends StatefulWidget {
  @override
  ComplaintsState createState() => new ComplaintsState();
}

class ComplaintsState extends State<Complaints> {
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
          .collection('Requests')
          .document('Complaints')
          .collection('Complaints')
          .where("UID", isEqualTo: uid)
          .getDocuments();
    });
    super.initState();
  }

  void validateAndSubmit() async {
    created = DateTime.now();
    formKey.currentState.save();
    await Firestore.instance
        .collection('Requests')
        .document('Complaints')
        .collection('Complaints')
        .document()
        .setData({
      'Title': title,
      'Details': details,
      //'Building': building,
      //'Floor': floor,
      //'Room': room,
      'Status': "Pending",
      'Created': created,
      //'Housing_Emp': "",
      'UID': uid,


    });
    final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('Complaints/${uid}_${created}');
    final StorageUploadTask task = firebaseStorageRef.putFile(_image);

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
                  text: 'My Complaints',
                ),
                Tab(
                  text: 'Create New Complaint',
                ),
              ],
            ),
            title: Text(
              'Complaint',
              
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
                      child: Text('My Complaints',
                          style: TextStyle(
                              fontSize: 22.0,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 15.0),
                    new StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection('Requests')
                            .document('Complaints')
                            .collection('Complaints')
                            .where('UID', isEqualTo: uid)
                            .where('Status', isEqualTo: 'Pending')
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
                                  return new ListTile(
                                    title:
                                        new Text('Title: ${document['Title']}'),
                                    subtitle: new Text(
//                                        'Status: ${document['Status']}'),
                                        'Created: ${document['Created'].toString()}\n Status: ${document['Status']}'),

                                    onTap: () {}, // view user detaild TODO
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
                padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                child: Form(
                  key: formKey,
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Title:',
                            labelStyle: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),
                          onSaved: (value) => title = value,
                          validator: (value) {
                            if (value.isEmpty) {
                              // The form is empty
                              return "Field can\'t be empty";
                            }
                          }),
                      TextFormField(
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            labelText: 'Description:',
                            labelStyle: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),
                          onSaved: (value) => details = value,
                          validator: (value) {
                            if (value.isEmpty) {
                              // The form is empty
                              return "Field can\'t be empty";
                            }
                          }),
                      SizedBox(height: 60.0),
                      SizedBox(height: 35.0),
                      new FloatingActionButton(
                        onPressed: getImage,
                        tooltip: 'Pick Image',
                        child: new Icon(Icons.add_a_photo),
                      ),
                      SizedBox(height: 35.0),
                      Container(
                        height: 45.0,
                        padding: EdgeInsets.only(left: 70.0, right: 70.0),
                        child: RaisedButton(
                            child: Text(
                              'Submit Complaint',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            splashColor: Colors.lightGreen,
                            onPressed: () {
                              _handlePressed(context);
                            }),
                      ),
                      SizedBox(height: 50.0),
                    ],
                  ),
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
