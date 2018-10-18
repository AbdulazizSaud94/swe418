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
  String role = "Student";
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
          child: ListView(
            shrinkWrap: true,
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
              new DropdownButton<String>(
                hint: Text(role,
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54)),
                items: <String>['Student', 'Housing', 'Security']
                    .map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  this.setState(() {
                    Text(value,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54));
                    role = value;
                  });
                },
              ),
              SizedBox(height: 20.0),
              new Builder(builder: (BuildContext context) {
                return Container(
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
                      onPressed: () async {
                        if (validateAndSave()) {
                          FirebaseUser user = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: email, password: password)
                              .catchError((e) {
                            print('Oops Error: $e');
                            final snackBar = SnackBar(
                              content: Text(
                                'Error: User already registered!',
                                style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );

                            // Find the Scaffold in the Widget tree and use it to show a SnackBar!
                            Scaffold.of(context).showSnackBar(snackBar);
                          });
                          Firestore.instance
                              .collection('Users')
                              .document(user.uid)
                              .setData(
                                  {'Email': email, 'Name': name, 'Role': role});
                          Navigator.of(context)
                              .pushReplacementNamed('/AdminTabs');
                        }
                      }),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
