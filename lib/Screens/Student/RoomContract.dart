import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RoomContract extends StatefulWidget {
  @override
  RoomContractState createState() => new RoomContractState();
}

DocumentSnapshot doc;
DateTime contract;
bool show = false;
String renew = 'Valid Contract';

class RoomContractState extends State<RoomContract> {
  String uid;
  String building;
  String room;
  String stu1;
  String stu2;
  String name;

  String buidingRef;
  String roomRef;

  bool bol1 = false;
  bool bol2 = false;

  final currentTime = DateTime.now();
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) async {
      this.uid = user.uid;
      await Firestore.instance
          .collection('Users')
          .document(uid)
          .get()
          .then((data) {
        if (data.exists) {
          setState(() {
            bol1 = true;
          });
          name = data.data['Name'];
          building = data.data['Building'];
          room = data.data['Room'];
        }
      });

      await Firestore.instance
          .collection('RoomContract')
          .where('student', isEqualTo: uid)
          .getDocuments()
          .then((data) async {
        if (data.documents.isNotEmpty) {
          setState(() {
            bol2 = true;
          });
          doc = data.documents.elementAt(0);
        }
        contract = doc.data['contract_date'];
        if (currentTime.isAfter(contract)) {
          renew = 'Unvalid Contract';
          show = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'My Room Contract',
        ),
        backgroundColor: Colors.lightGreen.withOpacity(0.8),
      ),
      body: new StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('RoomContract')
              .where('student', isEqualTo: uid)
              .snapshots(),
          builder: (context, snap) {
            if (!bol1 && !bol2)
              return new Center(
                child: new CircularProgressIndicator(),
              );
            return new ListView(children: <Widget>[
              new Stack(
                children: <Widget>[
                  Positioned(
                    top: 20.0,
                    child: Container(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 5.0),
                            child: Text(
                              'Contract Information',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 60.0,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 5.0),
                          child: Stack(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Building: $building',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.only(top: 60.0)),
                                  Text(
                                    'Room: $room',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.only(top: 105.0)),
                                  Text(
                                    'Resident: $name',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.only(top: 150.0)),
                                  Text(
                                    'Contract Duo:$contract',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.only(top: 195.0)),
                                  Text(
                                    'Contract Status:$renew',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.only(top: 260.0)),
                                  _Button(b: show)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    child: Container(
                      padding: EdgeInsets.only(top: 470.0),
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[],
                      ),
                    ),
                  ),
                ],
              ),
            ]);
          }),
    );
  }
}

class _Button extends StatelessWidget {
  bool b;

  _Button({@required this.b});
  Widget build(BuildContext context) {
    if (b)
      return RaisedButton(
        child: Icon(Icons.replay),
        onPressed: () {
          _handlePressed(context);
        },
      );
    return Text("");
  }

  void _handlePressed(BuildContext context) {
    confirmDialog(context).then((bool value) async {
      if (value) {
        validateAndSubmit(context);
      }
    });
  }

  void validateAndSubmit(context) async {
    DateTime time = DateTime.now().add(new Duration(days: 120));
    Firestore.instance.runTransaction((transaction) async {
      DocumentSnapshot ds = await transaction.get(doc.reference);
      await transaction.update(ds.reference, {'contract_date': time});
    });
    contract = time;
    show = false;
    renew = 'Valid Contract';
  }

  Future<bool> confirmDialog(BuildContext context) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text("Renew Contract?"),
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
}
