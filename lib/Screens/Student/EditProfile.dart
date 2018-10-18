import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  @override
  EditProfileState createState() => new EditProfileState();

  final String name;
  final String city;
  final String major;
  final String graduationTerm;
  final String smoking;
  final String mobile;
  final String intrestsHobbies;
  final String dislike;
  final String uid;
  final String email;

  //constructor
  EditProfile(
      {this.name,
      this.city,
      this.major,
      this.graduationTerm,
      this.smoking,
      this.mobile,
      this.intrestsHobbies,
      this.dislike,
      this.uid,
      this.email});
}

class EditProfileState extends State<EditProfile> {
  final formKey = GlobalKey<FormState>();
  String uid;
  String newName;
  String newCity = 'City';
  String newMobile;
  String newIntrestsHobbies;
  String newDislike;
  String newGraduationTerm;
  String newMajor;
  String newSmoking = 'Do you smoke?';

  DateTime birthDate = new DateTime(2000);

  Future<Null> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: birthDate,
        firstDate: new DateTime(1950),
        lastDate: DateTime.now());
    if (picked != null && picked != birthDate) {
      print('Birth Date: ${birthDate.toString()}');
      setState(() {
        birthDate = picked;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: new Text('Edit Profile'),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        child: Form(
          key: formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              TextFormField(
                initialValue: widget.name,
                onSaved: (value) => newName = value,
                validator: (value) {
                  if (value.isEmpty) {
                    // The form is empty
                    return "Field can\'t be empty";
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Name: ',
                  labelStyle: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ),
              SizedBox(height: 30.0),
              TextFormField(
                initialValue: widget.major,
                onSaved: (value) => newMajor = value,
                validator: (value) {
                  if (value.isEmpty) {
                    // The form is empty
                    return "Field can\'t be empty";
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Major: ',
                  labelStyle: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ),
              SizedBox(height: 30.0),
              TextFormField(
                initialValue: widget.graduationTerm,
                onSaved: (value) => newGraduationTerm = value,
                validator: (value) {
                  if (value.isEmpty) {
                    // The form is empty
                    return "Field can\'t be empty";
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Garduation Term: ',
                  labelStyle: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ),
              SizedBox(height: 30.0),
              TextFormField(
                initialValue: widget.mobile,
                onSaved: (value) => newGraduationTerm = value,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value.isEmpty) {
                    // The form is empty
                    return "Field can\'t be empty";
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Mobile Number: ',
                  labelStyle: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ),
              SizedBox(height: 30.0),
              TextFormField(
                  initialValue: widget.intrestsHobbies,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: 'Intrests & Hobbies:',
                    labelStyle: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                  onSaved: (value) => newIntrestsHobbies = value,
                  validator: (value) {
                    if (value.isEmpty) {
                      // The form is empty
                      return "Field can\'t be empty";
                    }
                  }),
              SizedBox(height: 30.0),
              TextFormField(
                  initialValue: widget.intrestsHobbies,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: 'Things I dislike:',
                    labelStyle: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                  onSaved: (value) => newDislike = value,
                  validator: (value) {
                    if (value.isEmpty) {
                      // The form is empty
                      return "Field can\'t be empty";
                    }
                  }),
              SizedBox(height: 30.0),
              Text(
                'City:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              DropdownButton<String>(
                hint: Text(widget.city,
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54)),
                items: <String>[
                  'Abha',
                  'Bisha',
                  'Al Bahah',
                  'Dammam',
                  'Dhahran',
                  'Hail',
                  'Al-Hasa',
                  'Hafr Al-Batin',
                  'Al Jawf',
                  'Jeddah',
                  'Jizan',
                  'Jubail',
                  'Khafji',
                  'Khobar',
                  'Al Majmaah',
                  'Mecca',
                  'Medina',
                  'Najran',
                  'Qatif',
                  'Qassim',
                  'Riyadh',
                  'Saihat',
                  'Taif',
                  'Tabuk',
                  'Yanbu'
                ].map((String value) {
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
                    newCity = value;
                  });
                },
              ),
              SizedBox(height: 30.0),
              Row(
                children: <Widget>[
                  Text(
                    'Birth Date:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    height: 30.0,
                    padding: EdgeInsets.only(right: 50.0, left: 20.0),
                    child: RaisedButton(
                      child: Text(
                        'Select Date',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        selectDate(context);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              Text(
                'Do you smoke?',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              DropdownButton<String>(
                hint: Text(widget.smoking,
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54)),
                items: <String>[
                  'I Don\'t Smoke',
                  'I Smoke',
                  'Not Specified',
                ].map((String value) {
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
                    newSmoking = value;
                  });
                },
              ),
              SizedBox(height: 40.0),
              Container(
                height: 50.0,
                padding: EdgeInsets.only(left: 65.0, right: 65.0),
                child: RaisedButton(
                    child: Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    splashColor: Colors.lightGreen,
                    onPressed: () async {
                      if (validateAndSave()) {
                        Firestore.instance
                            .collection('Users')
                            .document(widget.uid)
                            .updateData({'Name': newName, 'Email': widget.email, 'Role': 'Student', 'Mobile': newMobile, 'Major': newMajor,
                        'City': newCity, 'GraduationTerm': newGraduationTerm, 'Smoking': newSmoking, 'IntrestsHobbies': newIntrestsHobbies, 'Dislikes': newDislike});
                        Navigator.of(context)
                            .pushReplacementNamed('/ProfilePage');
                      }
                    }),
              ),
              SizedBox(height: 60.0),
            ],
          ),
        ),
      ),
    );
  }
}
