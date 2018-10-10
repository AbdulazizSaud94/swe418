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
}

class EditProfileState extends State<EditProfile> {
  final formKey = GlobalKey<FormState>();
  String uid;
  String name;
  String city = "City";

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

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) async {
      this.uid = user.uid;
      await Firestore.instance
          .collection('Users')
          .document(uid)
          .get()
          .then((data) {
        this.name = data['Name'];
      });
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: new Text('Edit Profile'),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
        child: Form(
          key: formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              TextFormField(
                initialValue: name,
                keyboardType: TextInputType.emailAddress,
                maxLength: 64,
                onSaved: (value) => name = value,
                validator: (value) {
                  if (value.isEmpty) {
                    // The form is empty
                    return "Field can\'t be empty";
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Name: ',
                  labelStyle: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ),
              SizedBox(height: 15.0),
              DropdownButton<String>(
                hint: Text(city,
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
                    city = value;
                  });
                },
              ),
              SizedBox(height: 15.0),
              Container(
                height: 30.0,
                width: 110.0,
                child:
                    RaisedButton(
                      child: Text('Select Date'),
                      onPressed: (){selectDate(context);},
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
