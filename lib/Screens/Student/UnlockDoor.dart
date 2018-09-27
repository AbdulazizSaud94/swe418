import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UnlockDoor extends StatefulWidget {
  @override
  UnlockDoorState createState() => new UnlockDoorState();
}

class UnlockDoorState extends State<UnlockDoor> {
  final formKey = GlobalKey<FormState>();
  String email;
  String name;
  String building;
  String room;
  String comment ;
  DateTime created;

 void validateAndSubmit(BuildContext context) async {
   created = DateTime.now();
   formKey.currentState.save();
   Firestore.instance.collection('Requests').document('UnlockDoor').collection('UnlockDoor').document().setData(
     {'Email': email, 'Name': name, 'Building': building, 'Room': room, 'Comment':comment, 'Status': "Pending", 'Created': created,
     'Housing_Emp': ""}
   );
   final snackBar = new SnackBar(
     content: new Text('Request Sent'),
     
   ); 
 }
  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user){
      Firestore.instance.collection("Users").document(user.uid).get().then((data){
        email = data['Email'];
        name = data['Name'];
        building = data['Building'];
        room = data['Room'];
      });
    });
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Unlock Door Request"),
      ),
      body: new Container(
        padding: EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
        child: new Form(
          key: formKey,
          child: new ListView(
            children: <Widget>[
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Text(
                    "building: $building, Room: $room",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              TextFormField(
                maxLength: 200,
                onSaved: (value) => comment = value,
                decoration: InputDecoration(
                  labelText: 'Comment:',
                  labelStyle: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ),
              Container(
                height: 50.0,
                width: 130.0,
                child: RaisedButton(
                    child: Text(
                      'Send Request',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    splashColor: Colors.lightGreen,
                    onPressed: () {
                      validateAndSubmit(context);
                    }),
              ),                                
            ],
          ),
        ),
      ),
    );
  }

}