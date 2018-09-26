import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageSate createState() => new LoginPageSate();
}

class LoginPageSate extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  String email;
  String password;

  //method to check for empty fields
  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  //method to validate input with fire base and login
  void validateAndSubmit() {
    if (validateAndSave()) {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((FirebaseUser user) {
        Firestore.instance
            .collection('Users')
            .document(user.uid)
            .get()
            .then((userRole) {
          if (userRole["Role"].toString().contains("Admin"))
            Navigator.of(context).pushReplacementNamed('/AdminTabs');
          else if (userRole["Role"].toString().contains("Student"))
            Navigator.of(context).pushReplacementNamed('/HomePage');
          else if (userRole["Role"].toString().contains("Housing"))
            Navigator.of(context).pushReplacementNamed('/HomePage');
        });
      }).catchError((e) {
        print(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Stack(
              //stack allow us to provide white space between two widgets
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                  child: Text('Welcome to',
                      style: TextStyle(
                          fontSize: 50.0, fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 160.0, 0.0, 0.0),
                  child: Text(
                    'STUHousing',
                    style:
                        TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(304.0, 115.0, 0.0, 0.0),
                  child: Text(
                    '.',
                    style: TextStyle(
                        fontSize: 110.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ),
              ],
            ),
          ),
          Form(
            key: formKey,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
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
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (value) => email = value,
                        maxLength: 64,
                        decoration: InputDecoration(
                          labelText: 'User Email',
                          labelStyle: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 140.0, left: 20.0, right: 20.0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        validator: (value) => value.isEmpty
                            ? 'Password field can\'t be empty'
                            : null,
                        onSaved: (value) => password = value,
                        maxLength: 64,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                        obscureText: true,
                      ),
                      Container(
                        alignment: Alignment(1.0, 0.0),
                        padding: EdgeInsets.only(top: 15.0, left: 20.0),
                        child: InkWell(
                          onTap: (){
                            FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        height: 50.0,
                        width: 500.0,
                        child: RaisedButton(
                          child: const Text(
                            'LOGIN',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          color: Colors.green,
                          elevation: 1.0,
                          splashColor: Colors.blueGrey,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          onPressed: validateAndSubmit,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
