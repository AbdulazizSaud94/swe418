import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'HSwapList.dart';

class AssignKey extends StatefulWidget {
  @override
  AssignKeyState createState() => new AssignKeyState();

  final String buildingID;
  final String buildingNumber;

  //constructor
  AssignKey({this.buildingID, this.buildingNumber});
}

class AssignKeyState extends State<AssignKey> {
  final formKey = GlobalKey<FormState>();
  String holderEmail;
  String holderMobile;

  //method to check for empty fields
  bool validateAndSave() {
    final form = formKey.currentState;
    form.save();
    if (form.validate()) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Assign holder'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 20.0,
          ),
          Text(
            ' Assign key holder to building ${widget.buildingNumber}:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17.0,
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Form(
            key: formKey,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 15, right: 150),
                  child: TextFormField(
                    onSaved: (value) => holderEmail = value,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty) {
                        // The form is empty
                        return "Field can\'t be empty";
                      }
                      // This is just a regular expression for email addresses
                      String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                          "\\@" +
                          "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
                          "(" +
                          "\\." +
                          "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
                          ")+";
                      RegExp regExp = new RegExp(p);

                      if (regExp.hasMatch(value)) {
                        // So, the email is valid
                        return null;
                      }

                      // The pattern of the email didn't match the regex above.
                      return 'Email is not valid';
                    },
                    decoration: InputDecoration(
                      labelText: 'Holder Email: ',
                      labelStyle: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
                Container(
                  padding: EdgeInsets.only(left: 15, right: 150),
                  child: TextFormField(
                    onSaved: (value) => holderMobile = value,
                    keyboardType: TextInputType.phone,
                    maxLength: 13,
                    validator: (value) {
                      if (value.isEmpty) {
                        // The form is empty
                        return "Field can\'t be empty";
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Holder Mobile:',
                      labelStyle: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 40.0,
                  padding: EdgeInsets.only(left: 110.0, right: 100.0),
                  child: RaisedButton(
                      child: Text(
                        'Assign holder',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      splashColor: Colors.lightGreen,
                      onPressed: () async {
                        if (validateAndSave()) {
                          await Firestore.instance
                              .collection('Building')
                              .document(widget.buildingID)
                              .updateData({
                            'key_holder': 'Not Housing',
                            'holder_email': holderEmail,
                            'holder_mobile': holderMobile,
                          });
                          Navigator.of(context).pop();
                        }
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
