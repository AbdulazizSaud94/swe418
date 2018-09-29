import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

String email;
class ViewPairing extends StatelessWidget  {
  @override
  Widget build(BuildContext context) {
   email=getdata('email');
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Pairing Requests'),
      ),
      body: new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Requests').document('Pairing').collection('PairingRequests').where('To',isEqualTo:'$email').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        return new ListView(
         shrinkWrap: true,
          children: snapshot.data.documents.map((DocumentSnapshot document) {
            return new ListTile(
              title: new Text(document['From']),
              trailing: new Row(
                
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Container(
                    width: 50.0,
                    child: new FlatButton(
                      child: Icon(Icons.check),
                      textColor: Colors.blueAccent, 
                        onPressed: () {
                          _handlePressed(context, document);},
                    ),
                  ),
                  
                  new Container(
                    width: 50.0,
                    alignment: Alignment(0.0, 0.0),
                    child: new FlatButton(
                      child: Icon(Icons.email),
                      textColor: Colors.blueAccent, 
                        onPressed: (){
                        String email = document['From'];
                        String url = 'mailto:' + email + '?subject=Pairing Request';
                          if ( canLaunch(url) != null) {
                             launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }                          
                        },
                    ),
                  ),
                ], 
              ), 
              onTap: (){},// view user detaild TODO
            );
          }).toList(),
        );
      },
    ),

    );

  }
  void _handlePressed(BuildContext context, DocumentSnapshot document){

        confirmDialog(context).then((bool value) async {
          if(value){
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      Firestore.instance.collection('Requests').document('Pairing').collection('HousingPairing').document().setData({'Student1': user.email,'Student2': document['From']});
      
            }
          });
    }
  
  


Future<bool> confirmDialog(BuildContext context){
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return new AlertDialog(
        title: new Text("Request Pairing?"),
        actions: <Widget>[
          new FlatButton(
            child: Text("Yes"),
            onPressed:() => Navigator.of(context).pop(true),
          ),
          new FlatButton(
            child: Text("No"),
            onPressed:() => Navigator.of(context).pop(false),
          ),
        ],
      );
    }
  );}
  setUser()async{
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  String email=user.email;
  return email;
  }

  String getdata(String geter) {
   
  FirebaseAuth.instance.currentUser().then((FirebaseUser user){
    Firestore.instance.collection("Users").document(user.uid).get().then((data){
     email=data['Email'];
  
    });
  });

    if (geter=='email')
    return email;
   return '0';
}
}