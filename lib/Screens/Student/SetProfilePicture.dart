import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class SetProfilePicture extends StatefulWidget {
  @override
  SetProfilePictureState createState() => new SetProfilePictureState();
  final String name;
  final String email;
  final String uid;

  //constructor
  SetProfilePicture({
    this.name,
    this.email,
    this.uid,
  });
}

class SetProfilePictureState extends State<SetProfilePicture> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Set Avatar'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
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
                    await Firestore.instance
                        .collection('Users')
                        .document(widget.uid)
                        .updateData({
                      'Avatar':
                          'https://firebasestorage.googleapis.com/v0/b/swe418-483b9.appspot.com/o/Avatars%2Fdefault.png?alt=media&token=da415113-0c8c-4fb7-b65e-23a41bb201bd',
                    });
                    Navigator.of(context).pushNamed('/ProfilePage');
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
