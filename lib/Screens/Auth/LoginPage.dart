import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:url_launcher/url_launcher.dart';

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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ListView(
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
                    'StuHousing',
                    style:
                        TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Positioned(
                  top: 175,
                  left: 295,
                  child: Container(
                    width: 48,
                    height: 45,
                    child: Image.asset(
                      'assets/images/newIcon.png',
                    ),
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
                            return "Email field can\'t be empty";
                          }
                          if (value.length > 64) {
                            // The form is empty
                            return "Email isddd not valid";
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
                        validator: (value) {
                          if (value.isEmpty) {
                            // The form is empty
                            return "Password field can\'t be empty";
                          }
                          if (value.length > 64) {
                            // The form is empty
                            return "Password is not valid";
                          }
                        },
                        onSaved: (value) => password = value,
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
                          onTap: _launchEmail,
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                                color: Colors.green.withGreen(416),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ),
                      SizedBox(height: 50.0),
                      new Builder(
                          // Create an inner BuildContext so that the onPressed methods
                          // can refer to the Scaffold with Scaffold.of().
                          builder: (BuildContext context) {
                        return Container(
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
                            color: Colors.green.withGreen(416),
                            elevation: 1.0,
                            splashColor: Colors.blueGrey,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            onPressed: () {
                              if (validateAndSave()) {
                                FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                        email: email, password: password)
                                    .then((FirebaseUser user) {
                                  Firestore.instance
                                      .collection('Users')
                                      .document(user.uid)
                                      .get()
                                      .then((userRole) {
                                    FirebaseMessaging fb =
                                        new FirebaseMessaging();

                                    fb.getToken().then((token) {
                                      Firestore.instance
                                          .collection('Users')
                                          .document(user.uid)
                                          .updateData({"token": token});
                                    });
                                    if (userRole["Role"]
                                        .toString()
                                        .contains("Admin"))
                                      Navigator.of(context)
                                          .pushReplacementNamed('/AdminTabs');
                                    else if (userRole["Role"]
                                        .toString()
                                        .contains("Student"))
                                      Navigator.of(context)
                                          .pushReplacementNamed('/ProfilePage');
                                    else if (userRole["Role"]
                                        .toString()
                                        .contains("Housing"))
                                      Navigator.of(context)
                                          .pushReplacementNamed('/HousingPage');
                                  });
                                }).catchError((e) {
                                  print('Error: $e');
                                  final snackBar = SnackBar(
                                    content: Text(
                                      'Incorrect user email or password!',
                                      style: TextStyle(
                                        fontSize: 17.0,
                                      ),
                                    ),
                                  );

                                  // Find the Scaffold in the Widget tree and use it to show a SnackBar!
                                  Scaffold.of(context).showSnackBar(snackBar);
                                });
                              }
                            },
                          ),
                        );
                      }),
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

_launchEmail() async {
  String url =
      'mailto:admin@admin.com?subject=Forgot%20Password&body=User%20Email:';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
