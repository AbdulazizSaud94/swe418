import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class RequestMaintenance extends StatefulWidget {
  @override
  RequestMaintenanceState createState() => new RequestMaintenanceState();
}

class RequestMaintenanceState extends State<RequestMaintenance> {
  final formKey = GlobalKey<FormState>();
  String title;
  String details;
  String building;
  String floor;
  String room;
  DateTime created;
  String uid;
  bool bol = false;
  File _image;
  var stream;

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
      if (user.uid.isNotEmpty) {
        setState(() {
          bol = true;
          this.uid = user.uid;
        });
        stream = stream = Firestore.instance
            .collection('Requests')
            .document('Maintenance')
            .collection('Maintenance')
            .where('UID', isEqualTo: uid)
            .where('Status', isEqualTo: 'Pending')
            .snapshots();
      }
    });
    super.initState();
  }

  void validateAndSubmit() async {
    created = DateTime.now();
    formKey.currentState.save();
    await Firestore.instance
        .collection('Requests')
        .document('Maintenance')
        .collection('Maintenance')
        .document()
        .setData({
      'Title': title,
      'Details': details,
      'Building': building,
      'Floor': floor,
      'Room': room,
      'Status': "Pending",
      'Created': created,
      'Housing_Emp': "",
      'UID': uid,
      'Attachment': '${uid}_${created}',
    });
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('MaintenanceRequests/${uid}_${created}');
    final StorageUploadTask task = firebaseStorageRef.putFile(_image);
    _showToast(context, "Request is generated successfully!");
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
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
                  text: 'My Requests',
                ),
                Tab(
                  text: 'Create New Request',
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
              'Maintenance Requests',
            ),
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
                      child: Text('MY Maintnance Requests',
                          style: TextStyle(
                              fontSize: 22.0,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 15.0),
                    new StreamBuilder<QuerySnapshot>(
                        stream: stream,
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
                                    return new ListTile(
                                      title: new Text(
                                          'Title: ${document['Title']}'),
                                      subtitle: new Text(
//                                        'Status: ${document['Status']}'),
                                          'Created: ${document['Created'].toString()}\n Status: ${document['Status']}'),

                                      onTap: () {}, // view user detaild TODO
                                    );
                                  }).toList(),
                                ),
                              ],
                            );
                          } else {
                            return new Text('  You Have No Requests');
                          }
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
                            labelText: 'Request Title:',
                            labelStyle: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),
                          onSaved: (value) {
                            setState(() {
                              title = value;
                            });
                          },
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
                            labelText: 'Details of Maintenance Reqired:',
                            labelStyle: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),
                          onSaved: (value) {
                            setState(() {
                              details = value;
                            });
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              // The form is empty
                              return "Field can\'t be empty";
                            }
                          }),
                      SizedBox(height: 60.0),
                      Container(
                        child: Text('Maintenance Location',
                            style: TextStyle(
                                fontSize: 25.0,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(height: 5.0),
                      Container(
                        padding: EdgeInsets.only(right: 277.0),
                        child: TextFormField(
                            maxLength: 3,
                            decoration: InputDecoration(
                              labelText: 'Building:',
                              labelStyle: TextStyle(
                                  fontSize: 14.0, color: Colors.black54),
                            ),
                            keyboardType: TextInputType.number,
                            onSaved: (value) => building = value,
                            validator: (value) {
                              if (value.isEmpty) {
                                // The form is empty
                                return "Field can\'t be empty";
                              }
                            }),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 277.0),
                        child: TextFormField(
                            maxLength: 1,
                            decoration: InputDecoration(
                              labelText: 'Floor:',
                              labelStyle: TextStyle(
                                  fontSize: 14.0, color: Colors.black54),
                            ),
                            keyboardType: TextInputType.number,
                            onSaved: (value) => floor = value,
                            validator: (value) {
                              if (value.isEmpty) {
                                // The form is empty
                                return "Field can\'t be empty";
                              }
                            }),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 277.0),
                        child: TextFormField(
                            maxLength: 3,
                            decoration: InputDecoration(
                              labelText: 'Room:',
                              labelStyle: TextStyle(
                                  fontSize: 14.0, color: Colors.black54),
                            ),
                            keyboardType: TextInputType.number,
                            onSaved: (value) => room = value,
                            validator: (value) {
                              if (value.isEmpty) {
                                // The form is empty
                                return "Field can\'t be empty";
                              }
                            }),
                      ),
                      SizedBox(height: 25.0),
                      Container(
                        width: 70,
                        child: FlatButton(
                          child: Icon(
                            Icons.add_a_photo,
                            size: 35,
                          ),
                          textColor: Colors.grey,
                          onPressed: () {
                            getImage();
                          },
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Container(
                        height: 45.0,
                        padding: EdgeInsets.only(left: 70.0, right: 70.0),
                        child: RaisedButton(
                            color: Colors.green,
                            splashColor: Colors.blueGrey,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0)),
                            child: Text(
                              'Send Request',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
    confirmDialog(context).then((bool value) {
      if (value) {
        validateAndSubmit();
        Navigator.of(context).pushReplacementNamed('/RequestMaintenance');
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
