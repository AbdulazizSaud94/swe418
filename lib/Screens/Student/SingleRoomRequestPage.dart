import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class SingleRoomRequestPage extends StatefulWidget {
  @override
  SingleRoomRequestPageState createState() => new SingleRoomRequestPageState();
}

class SingleRoomRequestPageState extends State<SingleRoomRequestPage> {
  final formKey = GlobalKey<FormState>();
  String request;
  String status = 'Pending';
  DateTime created;
  String uid;
  bool bol = false;
  var stream;

  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      if (user.uid.isNotEmpty) {
        setState(() {
          bol = true;
          this.uid = user.uid;
        });
        stream = Firestore.instance
            .collection('Requests')
            .document('SingleRoom')
            .collection('SingleRoom')
            .where('User_ID', isEqualTo: uid)
            .where('Status', isEqualTo: 'Pending')
            .snapshots();
      }
    });
    super.initState();
  }

  //method to check for empty fields
  bool validateAndSave() {
    final form = formKey.currentState;
    form.save();
    if (form.validate()) {
      return true;
    }
    return false;
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

  void validateAndSubmit() async {
    //final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('SingleRoomRequests/${uid}_${created}');
    //final StorageUploadTask task = firebaseStorageRef.putFile(_image);

    created = DateTime.now();
    formKey.currentState.save();
    await Firestore.instance
        .collection('Requests')
        .document('SingleRoom')
        .collection('SingleRoom')
        .document()
        .setData({
      'Request_Body': request,
      'Status': status,
      'Created': created,
      'User_ID': uid,
      'Attachment': '${uid}_${created}',
    });
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('SingleRoomRequests/${uid}_${created}');
    final StorageUploadTask task = firebaseStorageRef.putFile(_image);
    _showToast(context, "Request is generated successfully!");
    // print(firebaseStorageRef.getDownloadURL().toString());

    sucessDialog(context).then((bool value) async {
      if (value) {
        Navigator.of(context).pushReplacementNamed('/RequestsPage');
      }
    });
  }

  Future<bool> confirmDialog(BuildContext context) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text("Send Request"),
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

  Future<bool> sucessDialog(BuildContext context) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text("Request has been created"),
            actions: <Widget>[
              new FlatButton(
                child: Text("Ok"),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        });
  }

  void _handlePressed(BuildContext context) {
    confirmDialog(context).then((bool value) async {
      if (value) {
        validateAndSubmit();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
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
            title: Text(
              'Single Room Request',
            ),
            centerTitle: true,
          ),
          body: TabBarView(
            children: [
              //first tab
              Container(
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 30.0),
                    Container(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text('My Requests',
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
                                          'Title: ${document['Request_Body']}'),
                                      subtitle: new Text(
                                          //'Status: ${document['Status']}'),
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
              //second tab
              Container(
                padding: EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
                child: Form(
                  key: formKey,
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLength: 512,
                        onSaved: (value) => request = value,
                        validator: (value) {
                          if (value.isEmpty) {
                            // The form is empty
                            return "Field can't be empty";
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Request Description:',
                          labelStyle: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                        maxLines: 5,
                      ),
                      FlatButton(
                        child: Icon(Icons.attach_file),
                        textColor: Colors.grey,
                        onPressed: () {
                          getImage();
                        },
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 110),
                        child: uploaded(),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        height: 50.0,
                        width: 130.0,
                        child: RaisedButton(
                            color: Colors.green,
                            splashColor: Colors.blueGrey,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0)),
                            child: Text(
                              'Submit',
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

  Widget uploaded() {
    if (_image == null) {
      return Text('no attachment');
    }
    return Text('attachment added');
  }
}
