import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SingleRoomRequestPage extends StatefulWidget {
  @override
  SingleRoomRequestPageState createState() => new SingleRoomRequestPageState();
}

class SingleRoomRequestPageState extends State<SingleRoomRequestPage> {
  final formKey = GlobalKey<FormState>();
  String request;
  String role = "Student";

  //method to check for empty fields
  bool validateAndSave() {
    final form = formKey.currentState;
    form.save();
    if (form.validate()) {
      return true;
    }
    return false;
  }

  /*void validateAndSubmit() async {
    if (validateAndSave()) {
      FirebaseUser user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      Firestore.instance.collection('Users').document(user.uid).setData({'Email': email,'Name': name, 'Role': role});
      Navigator.of(context).pushReplacementNamed('/AdminTabs');
    }
  }*/

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
                  // Navigator.pop(context);
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => new EditUserPage(
                  //               document: document,
                  //             )));
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
                      //validateAndSubmit();
                    }),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
