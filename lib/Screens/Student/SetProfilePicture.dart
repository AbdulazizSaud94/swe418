import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SetProfilePicture extends StatefulWidget {
  @override
  SetProfilePictureState createState() => new SetProfilePictureState();
  final String name;
  final String email;
  final String uid;
  final String avatar;

  //constructor
  SetProfilePicture({
    this.name,
    this.email,
    this.uid,
    this.avatar,
  });
}

class SetProfilePictureState extends State<SetProfilePicture> {
  File _image;
  DateTime updated = DateTime.now();
  String imageUrl;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('Avatars/${widget.uid}_$updated.png');

    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);

    var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    imageUrl = dowurl.toString();

    print("Download URL:\n$imageUrl");

    Firestore.instance.collection('Users').document(widget.uid).updateData({
      'Avatar': imageUrl,
    });

    Navigator.of(context).pushNamed('/ProfilePage');
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Set Avatar'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Column(
            children: <Widget>[
              Center(
                child: Container(
                  padding: EdgeInsets.fromLTRB(300, 0, 300, 0),
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      image: DecorationImage(
                          image: NetworkImage(widget.avatar), fit: BoxFit.fill),
                      borderRadius: BorderRadius.all(Radius.circular(75.0)),
                      boxShadow: [
                        BoxShadow(blurRadius: 20.0, color: Colors.black),
                      ]),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 60,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(120, 0, 120, 0),
            child: RaisedButton(
                child: Text(
                  'Set New',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                color: Colors.grey.withOpacity(0.78),
                elevation: 1.0,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(50.0)),
                onPressed: () {
                  getImage();
                }),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(120, 0, 120, 0),
            child: RaisedButton(
                child: Text(
                  'Set Default',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                color: Colors.grey.withOpacity(0.78),
                elevation: 1.0,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(50.0)),
                onPressed: () {
                  confirmDefaultDialog(context).then((bool value) async {
                    if (value) {
                      await Firestore.instance
                          .collection('Users')
                          .document(widget.uid)
                          .updateData({
                        'Avatar':
                            'https://firebasestorage.googleapis.com/v0/b/swe418-483b9.appspot.com/o/Avatars%2Fdefault.png?alt=media&token=da415113-0c8c-4fb7-b65e-23a41bb201bd',
                      });
                      Navigator.of(context).pushNamed('/ProfilePage');
                    }
                  });
                }),
          ),
        ],
      ),
    );
  }
}

Future<bool> confirmDefaultDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text("Set default avatar?"),
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

Future<bool> confirmSetDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text("Set avatar?"),
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
