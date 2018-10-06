import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditUserPage extends StatefulWidget {
  final DocumentSnapshot document;
  EditUserPage({@required this.document});

  @override
  EditState createState() => new EditState(document: document);


}


class EditState extends State<EditUserPage> {
  final formKey = GlobalKey<FormState>();
  final DocumentSnapshot document;
  EditState({@required this.document});
  String name;

 bool validateAndSave() {
    final form = formKey.currentState;
    form.save();
    if (form.validate()) {
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot ds = await transaction.get(document.reference);
        await transaction.update(ds.reference,{'Name': name});
      });
      Navigator.of(context).pushReplacementNamed('/UserList');
    }
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Edit On ${document["Name"]}'),
      ),
      body: Container(
         padding: EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
         child: Form(
           key: formKey,
           child: ListView(
             shrinkWrap: true,
             children: <Widget>[
               TextFormField(
                 initialValue: document['name'],
                 onSaved: (value) => name = value,
                 validator: (value) {
                   if (value.isEmpty) {
                    return 'Field can\'t be empty';
                  }
                 },
                 decoration: InputDecoration(
                   labelText: "${document['Name']}",
                   labelStyle: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54
                   )
                 ),
               ),

               SizedBox(height: 20.0),
              Container(
                height: 50.0,
                width: 130.0,
                child: RaisedButton(
                    child: Text(
                      'Save Changes',
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
      )
    );
  }

}