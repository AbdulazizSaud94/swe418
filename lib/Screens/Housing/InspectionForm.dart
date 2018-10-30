import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InspectionForm extends StatefulWidget {
  @override
  InspectionFormSate createState() => new InspectionFormSate();
}

class InspectionFormSate extends State<InspectionForm> {
  final formKey = GlobalKey<FormState>();
  String roomNo;
  String bldgNo;
  String date;
  String details;
String uName;
    
  
  @override
  Widget build(BuildContext context) {
        FirebaseAuth.instance.currentUser().then((FirebaseUser user) async {
      String uid = user.uid;
      await Firestore.instance
          .collection('Users')
          .document(uid)
          .get()
          .then((data) {
        uName = data['Name']; 
      });
    });
   return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
                appBar: AppBar(
                  
            bottom: TabBar(
              tabs: [
                Tab(
                  text: 'Incpections list',
                ),
                Tab(
                  text: 'New Incpection',
                ),
              ],
            ),
            title: Text(
              'Incpection Requests',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: TabBarView(
            children: [
              //First tab
              Container(
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 30.0),
                    Container(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text('Inpections',
                          style: TextStyle(
                              fontSize: 22.0,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 15.0),
                     new StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
             .collection('InspectionList')
            .where('Status', isEqualTo: 'Pending')
            .orderBy('Created')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData){
              return new Center(
                child: new CircularProgressIndicator(),
              );
            }
            return new ListView(shrinkWrap: true, children: <Widget>[
              new ListView(
                shrinkWrap: true,
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  return new ExpansionTile(
                  title: new Text('Building: ${document['Building'].toString()}'+'  Room: ${document['Room'].toString()}'),
                  children: <Widget>[
                      new Text('Details: ${document['Details']}', textAlign: TextAlign.left),
                      new Text('Inspector: ${document['InspectorName']}'),
                      new Text('Created: ${document['Created'].toString()}'),
                  ],
                  trailing: new Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Container(
                          width: 50.0,
                          child: new FlatButton(
                            child: Icon(Icons.done),
                            textColor: Colors.blueAccent,
                            onPressed: () {
                             _handle(context, document, "Done");
                                          },
                                        ),
                                      ),
              
                                      new Container(
                                        width: 50.0,
                                        child: new FlatButton(
                                          child: Icon(Icons.delete),
                                          textColor: Colors.blueAccent,
                                          onPressed: () {
                                          _handle(context, document, "Decline");
                                          },
                                        ),
                                      ),
                                    ] ));}).toList(),
                            ),
                          ]);
                        }),
                              
                          ])
                          ),
                            //2nd Tab
                            Container(
                              child: ListView(
                      children: <Widget>[
                        Container(
                          child: Stack(
                            //stack allow us to provide white space between two widgets
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(100.0, 30.0, 0.0, 0.0),
                                child: Text('Inspection Form',
                                    style: TextStyle(
                                        fontSize: 25.0, fontWeight: FontWeight.bold)),
                              ),
              
                
                            ])),
                            
                            Form( 
                              key: formKey,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
                                child: Column(
                                  children: <Widget>[
                            TextFormField(
                                      
                                      decoration: InputDecoration(
                                        labelText: 'Building Number',
                                        labelStyle: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54),
                                      ),
                                      keyboardType: TextInputType.number,
                                      onSaved: (value) => bldgNo = value,
                                      maxLength: 4,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              // The form is empty
                                              return "Field can\'t be empty";}}
                                    ),
                            ])),
                                  Container(
                                padding: EdgeInsets.only(top: 90.0, left: 20.0, right: 20.0),
                                child: Column(
                                  children: <Widget>[
                            TextFormField(
                                      keyboardType: TextInputType.number,
                                      validator: (value) => value.isEmpty
                                          ? 'Room Number field can\'t be empty'
                                          : null,
                                      onSaved: (value) => roomNo = value,
                                      maxLength: 4,
                                      decoration: InputDecoration(
                                        labelText: 'Room Number',
                                        labelStyle: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54),
                                      ),
                                    ),
                            ])),
                                  Container(
                                padding: EdgeInsets.only(top: 180.0, left: 20.0, right: 20.0),
                                child: Column(
                                  children: <Widget>[
                            TextFormField(
                                      keyboardType: TextInputType.datetime,
                                      validator: (value) => value.isEmpty
                                          ? 'Date field can\'t be empty'
                                          : null,
                                      onSaved: (value) => date = value,
                                      maxLength: 10,
                                      decoration: InputDecoration(
                                        labelText: 'Date',
                                        labelStyle: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54),
                                      ),
                                    ),
                            ])),
                                Container(
                                padding: EdgeInsets.only(top: 280.0, left: 20.0, right: 20.0),
                                child: Column(
                                  children: <Widget>[
                                TextFormField(
                                        maxLines: 5,
                                        keyboardType: TextInputType.multiline,
                                        decoration: InputDecoration(
                                          labelText: 'Inspection Details',
                                          labelStyle: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black54),
                                        ),
                                        onSaved: (value) => details = value,
                                        validator: (value) {
                                          if (value=="") {
                                            // The form is empty
                                            return "Field can\'t be empty";
                                          }
                                        }),
                            ])),
                            
                      ])), 
                      Container(
                                      // height: 10.0,
                                      child: RaisedButton(
                                          child: Text('Submit',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          splashColor: Colors.lightGreen,
                                          onPressed: () {
                                            _handlePressed(context);
                                          }),
                                    ),
                      ]))]),
                 drawer: new Drawer(
            child: new ListView(
          children: <Widget>[
            new Container(
              height: 120.0,
              child: new DrawerHeader(
                padding: new EdgeInsets.all(0.0),
                decoration: new BoxDecoration(
                  color: new Color(0xFFECEFF1),
                ),
                child: new Center(
                  child: new FlutterLogo(
                    colors: Colors.lightGreen,
                    size: 54.0,
                  ),
                ),
              ),
            ),
            new Divider(),
            new ListTile(
                leading: new Icon(Icons.receipt),
               title: new Text('Requests Page'),
                onTap: () {
                   Navigator.of(context).pushReplacementNamed('/HousingPage');
                }),
            new ListTile(
                leading: new Icon(Icons.radio),
                title: new Text('Complaints'),
                onTap: () {
                  Navigator.of(context).pushNamed('/HComplaintsList');
                }),
            new ListTile(
                leading: new Icon(Icons.exit_to_app),
                title: new Text('Sign Out'),
                onTap: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    Navigator.of(context).pushReplacementNamed('/LoginPage');
                  }).catchError((e) {
                    print(e);
                  });
                }),
          ],
        ))

                )   
                
                
                
                
                    ));}
                
                             
                          
                          void _handlePressed(BuildContext context) {
                              confirmDialog(context).then((bool value) async {
                                if (value) {
                                  validateAndSubmit();
                                }
                              });
                            }
                          
                          
                          
                          
                          
                          
                          Future<bool> confirmDialog(BuildContext context) {
                            return showDialog<bool>(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return new AlertDialog(
                                    title: new Text("Submit?"),
                                    actions: <Widget>[
                                      new FlatButton(
                                        child: Text("Yes"),
                                        onPressed: () => Navigator.of(context).pop(true),
                                      ),
                                      new FlatButton(
                                        child: Text("No"),
                                        onPressed: () => Navigator.of(context).pop(false),
                                      ),
                                    ],
                                  );
                                });
                          }
                          
                          
                          //method to check for empty fields
                            bool validateAndSave() {
                              final form = formKey.currentState;
                              if (form.validate()) {
                                form.save();
                                return true;
                              }
                              return false;
                            }
                          
                          
                            void validateAndSubmit() async {
                                  formKey.currentState.save();
                              var created = DateTime.now();
                              if(validateAndSave()){
                              await Firestore.instance
                                  .collection('InspectionList')
                                  .document()
                                  .setData({
                                    'Created':created,
                                    'InspectorName':uName,
                                    'Building':bldgNo,
                                    'Room':roomNo,
                                    'Details':details,
                                    'Status':'Pending',
                                  
                              });
                              Navigator.of(context).popAndPushNamed('/InspectionForm');
                              }
                            }
                          
                            void _handle(BuildContext context, DocumentSnapshot document, String s) {
                            if (s.contains('Done')){
                              Firestore.instance.runTransaction((transaction) async {
                              DocumentSnapshot ds = await transaction.get(document.reference);
                              await transaction.update(ds.reference, {'Status' : 'Done'});
                            });}
                            else if(s.contains('Decline')){
                              Firestore.instance.runTransaction((transaction) async {
                              DocumentSnapshot ds = await transaction.get(document.reference);
                              await transaction.update(ds.reference, {'Status' : 'Declined'});
                            });}
                            }



                            }
