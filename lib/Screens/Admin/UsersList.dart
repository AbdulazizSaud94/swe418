import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'EditUserPage.dart';
import 'package:flutter_test/flutter_test.dart';

class UsersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Users List'),
      ),
      body: new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Users').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        return new ListView(
         shrinkWrap: true,
          children: snapshot.data.documents.map((DocumentSnapshot document) {
            return new ListTile(
              title: new Text(document['Name']),
              subtitle: new Text(document['Email']),
              trailing: new Row(
                
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Container(
                    width: 50.0,
                    child: new FlatButton(
                      child: Icon(Icons.delete_forever),
                      textColor: Colors.grey,
                        onPressed: () {_handlePressed(context, document);},
                    ),
                  ),
                  
                  new Container(
                    width: 50.0,
                    alignment: Alignment(0.0, 0.0),
                    child: new FlatButton(
                      child: Icon(Icons.edit),
                      textColor: Colors.grey,
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => new EditUserPage(document: document,)
                          ));
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
            Firestore.instance.runTransaction((transaction) async {
              DocumentSnapshot ds = await transaction.get(document.reference);
              await transaction.delete(ds.reference);
            });
          }
    });
  }
  
}

Future<bool> confirmDialog(BuildContext context){
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return new AlertDialog(
        title: new Text("Delete User?"),
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

  );

}