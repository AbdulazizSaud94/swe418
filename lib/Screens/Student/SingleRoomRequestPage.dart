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
          .document('Maintenance')
          .collection('Maintenance')
          .where("UID", isEqualTo: uid)
          .getDocuments();
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

  void validateAndSubmit() async {
    final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('SingleRoomRequests/${uid}_${created}');
    final StorageUploadTask task = firebaseStorageRef.putFile(_image);

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
      //'Reference': firebaseStorageRef.getDownloadURL().toString(),
    });
    
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
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: new Text('Create Request'),
        centerTitle: true,
      ),
      body: Container(
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
                textColor: Colors.blueAccent,
                onPressed: () {
                  getImage();
                },
              ),
              SizedBox(height: 20.0),
              Container(
                height: 50.0,
                width: 130.0,
                child: RaisedButton(
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    splashColor: Colors.lightGreen,
                    onPressed: () {
                      _handlePressed(context);
                    }),
              ),

            ],
          ),
        ),
      ),
    );
  }
}