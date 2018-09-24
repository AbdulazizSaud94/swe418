import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddUserPage extends StatefulWidget {
  @override
  AddUserPageState createState() => new AddUserPageState();
}

class AddUserPageState extends State<AddUserPage> {
  final formKey = GlobalKey<FormState>();
  String email;
  String name;
  String role;
  String password;
  String repeatPassword;

  //method to check for empty fields
  bool validateAndSave() {
    final form = formKey.currentState;
    form.save();
    if (form.validate()) {
      return true;
    }
    return false;
  }

  void validateAndSubmit() {
    if (validateAndSave()) {
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      Firestore.instance.collection('Users').document().setData({'Email': email,'Name': name, 'Role': role});
      Navigator.of(context).pushReplacementNamed('/AdminTabs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: new Text('Add User'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                maxLength: 64,
                onSaved: (value) => email = value,
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
                  labelText: 'User Email:',
                  labelStyle: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                maxLength: 64,
                onSaved: (value) => name = value,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Field can\'t be empty';
                  }
                },
                decoration: InputDecoration(
                  labelText: 'User name:',
                  labelStyle: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                maxLength: 64,
                onSaved: (value) => password = value,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Field can\'t be empty';
                  } else if (value != repeatPassword) {
                    return 'Passwords don\'t match';
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Password:',
                  labelStyle: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20.0),
              TextFormField(
                maxLength: 64,
                onSaved: (value) => repeatPassword = value,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Field can\'t be empty';
                  } else if (value != password) {
                    return 'Passwords don\'t match';
                  }
                },
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Repeat Password:',
                  labelStyle: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                maxLength: 64,
                onSaved: (value) => role = value,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Field can\'t be empty';
                  }
                },
                decoration: InputDecoration(
                  labelText: 'User Role:',
                  labelStyle: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                height: 50.0,
                width: 130.0,
                child: RaisedButton(
                    child: Text(
                      'Create User',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    splashColor: Colors.lightGreen,
                    onPressed: () {
                      validateAndSubmit();
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
