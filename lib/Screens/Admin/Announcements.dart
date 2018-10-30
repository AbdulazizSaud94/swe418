import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Announcements extends StatefulWidget {
  @override
  AnnouncementsState createState() => new AnnouncementsState();
}

class AnnouncementsState extends State<Announcements> {
  final formKey = GlobalKey<FormState>();
  String title;
  String details;
  DateTime created;
  String uid;
  String userEmail;
  QuerySnapshot doc;

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) async {
      this.uid = user.uid;
      this.userEmail = user.email;
      doc = await Firestore.instance.collection('Announcements').getDocuments();
    });
    super.initState();
  }

  void validateAndSubmit() async {
    created = DateTime.now();
    formKey.currentState.save();
    await Firestore.instance.collection('Announcements').document().setData({
      'Title': title,
      'Details': details,
      'Created': created,
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
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
                  text: 'All Announcements',
                ),
                Tab(
                  text: 'New Announcement',
                ),
              ],
            ),
            title: Text(
              'Announcements',
            ),
          ),
          body: TabBarView(
            children: [
              //First tab
              Container(
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 30.0),
                    new StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance.collection('Announcements').orderBy('Created', descending: true).snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) return new Text('Loading...');
                        return new ListView(
                          shrinkWrap: true,
                          children: snapshot.data.documents.map((DocumentSnapshot document) {
                            return new ListTile(
                              title:  ExpansionTile(
                                title: Text(
                                  '${document['Title']}\n${document['Created']}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                children: <Widget>[
                                  Text('${document['Details']}\n',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),),
                                ],
                              ),
                              trailing: new Row(

                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Container(
                                    width: 50.0,
                                    child: new FlatButton(
                                      child: Icon(Icons.delete_forever),
                                      textColor: Colors.grey,
                                      onPressed: () {
                                        DeleteDialog(context).then((bool value) async {
                                          if(value){
                                            Firestore.instance.runTransaction((transaction) async {
                                              DocumentSnapshot ds = await transaction.get(document.reference);
                                              await transaction.delete(ds.reference);
                                            });
                                          }
                                        });
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
                  ],
                ),
              ),
              //Second tab
              Container(
                padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                child: Form(
                  key: formKey,
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      SizedBox(height: 40.0),
                      TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Announcement Title:',
                            labelStyle: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),
                          onSaved: (value) => title = value,
                          validator: (value) {
                            if (value.isEmpty) {
                              // The form is empty
                              return "Field can\'t be empty";
                            }
                          }),
                      SizedBox(height: 50.0),
                      TextFormField(
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            labelText: 'Details Announcement:',
                            labelStyle: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),
                          onSaved: (value) => details = value,
                          validator: (value) {
                            if (value.isEmpty) {
                              // The form is empty
                              return "Field can\'t be empty";
                            }
                          }),
                      SizedBox(height: 50.0),
                      Container(
                        height: 45.0,
                        padding: EdgeInsets.only(left: 70.0, right: 70.0),
                        child: RaisedButton(
                            child: Text(
                              'Add Announcement',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            splashColor: Colors.lightGreen,
                            onPressed: () {
                              _handlePressed(context);
                            }),
                      ),
                      SizedBox(height: 50.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
          //Drawer
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
                  new ListTile(
                      leading: new Icon(Icons.account_balance),
                      title: new Text('Main'),
                      onTap: () {
                        Navigator.of(context).pushNamed('/AdminTabs');
                      }
                  ),
                  new ListTile(
                      leading: new Icon(Icons.add),
                      title: new Text('Add Users'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).pushNamed('/AddUserPage');
                      }
                  ),
                  new ListTile(
                      leading: new Icon(Icons.list),
                      title: new Text('Users List'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).pushNamed('/UsersList');
                      }
                  ),
                  // new ListTile(
                  //   leading: new Icon(Icons.delete),
                  //   title: new Text('Delete Users'),
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     Navigator.of(context).pushNamed('/DeleteUsers');
                  //   }
                  // ),
                  new Divider(),
                  new ListTile(
                      leading: new Icon(Icons.exit_to_app),
                      title: new Text('Sign Out'),
                      onTap: () {
                        FirebaseAuth.instance
                            .signOut()
                            .then((value) {
                          Navigator.of(context).pushReplacementNamed('/LoginPage');
                        })
                            .catchError((e) {
                          print(e);
                        });

                      }
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }

  void _handlePressed(BuildContext context) {
    confirmDialog(context).then((bool value) async {
      if (value) {
        validateAndSubmit();
      }
    });
  }
}

Future<bool> confirmDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text("Submit Announcement?"),
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

Future<bool> DeleteDialog(BuildContext context){
  return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text("Delete Announcement?"),
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
