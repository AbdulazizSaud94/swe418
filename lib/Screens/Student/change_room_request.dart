import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'RequestsPage.dart';

String email;

class RequestChangeRoomList extends StatefulWidget {
  _RequestChangeRoomList createState() => new _RequestChangeRoomList();
}

class _RequestChangeRoomList extends State<RequestChangeRoomList> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Available Room List'),
      ),
      body: new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('Room')
            .where('room_status', isEqualTo: 'available')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return new Text('Loading...');
          return new ListView(
            shrinkWrap: true,
            children: snapshot.data.documents.map((DocumentSnapshot document) {
              return new ListTile(
                title: new Text("Building: " + document['room_building']),
                subtitle: new Text("Room: " + document['room_number']),
                trailing: new Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Container(
                      width: 50.0,
                      child: new FlatButton(
                        child: Icon(Icons.add),
                        textColor: Colors.blueAccent,
                        onPressed: () {
                          addChangeRoomRequest(document['room_building'],
                              document['room_number']);
                        },
                      ),
                    ),
                  ],
                ),
                onTap: () {}, // view user detaild TODO
              );
            }).toList(),
          );
        },
      ),
    );
  }

  FirebaseUser user;

  //In this method I will get all data about the request including getting the roommate info
  addChangeRoomRequest(String room_building, String room_number) async {
    var roommate = "";
    var roommate_id = "";
    var user_id = "";
    FirebaseUser user;
    String room = room_number, building = room_building;
    await FirebaseAuth.instance.currentUser().then((FirebaseUser _user) {
      user = _user;
    });
    await Firestore.instance
        .collection("Users")
        .document(user.uid)
        .get()
        .then((data) {
      user_id = data.data['Email'];
    });

    await Firestore.instance
        .collection("Roommate")
        .where("resident_one", isEqualTo: user.uid)
        .getDocuments()
        .then((value) {
      if (!value.documents.isEmpty)
        roommate = value.documents[0].data['resident_two'];
    });

    if (roommate == "") {
      await Firestore.instance
          .collection("Roommate")
          .where("resident_two", isEqualTo: user.uid)
          .getDocuments()
          .then((value) {
        if (!value.documents.isEmpty)
          roommate = value.documents[0].data['resident_one'];
      });
    }

    await Firestore.instance
        .collection("Users")
        .document(roommate)
        .get()
        .then((data) {
      roommate_id = data.data['Email'];
    });

    Firestore.instance
        .collection("Requests")
        .document('ChangeRoom')
        .collection('ChangeRoom')
        .add({
      "requester": user.uid,
      "requester_id": user_id,
      "partner": roommate,
      "partner_id": roommate_id,
      "request_date": DateTime.now(),
      "partner_approve": "pending",
      "request_status": "partner",
      "requested_building": building,
      "requested_room": room
    }).then((a) {
      Navigator.pop(
          context, MaterialPageRoute(builder: (context) => ChangeRoomPage()));
    });
  }
}

class ChangeRoomPage extends StatefulWidget {
  // String room_building;
  // String room_number;
  // String room_status;
  // String room_type;

  _ChangeRoomPage createState() => new _ChangeRoomPage();
}

class _ChangeRoomPage extends State<ChangeRoomPage> {
  requestPage() {}

  partnerApprove(String _building, String _room) {
    String room = _room;
    String building = _building;
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      verticalDirection: VerticalDirection.down,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
            padding: new EdgeInsets.all(8.0),
            child: Text(
              "Your partner made a request changing to room: " +
                  building +
                  " / " +
                  room,
              style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
            )),
        RaisedButton(
            key: null,
            onPressed: () {
              Firestore.instance
                  .collection("Requests")
                  .document("ChangeRoom")
                  .collection("ChangeRoom")
                  .where("partner", isEqualTo: _user.uid)
                  .getDocuments()
                  .then((data) {
                if (!data.documents.isEmpty)
                  data.documents[0].reference.delete().then((a) {
                    Navigator.pop(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RequestsPage()));
                  });
              });
            },
            color: Colors.red,
            child: new Text(
              "Delete the request",
              style: new TextStyle(
                  fontSize: 17.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w200,
                  fontFamily: "Merriweather"),
            )),
        RaisedButton(
            key: null,
            onPressed: () {
              Firestore.instance
                  .collection("Requests")
                  .document("ChangeRoom")
                  .collection("ChangeRoom")
                  .where("partner", isEqualTo: _user.uid)
                  .getDocuments()
                  .then((data) {
                if (!data.documents.isEmpty)
                  data.documents[0].reference
                      .updateData({"partner_approve": "approve"}).then((a) {
                    Navigator.pop(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RequestsPage()));
                  });
              });
            },
            color: Colors.lightBlueAccent,
            child: new Text(
              "Approve",
              style: new TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w200,
                  fontFamily: "Merriweather"),
            ))
      ],
    );
  }

  waitingHousingApprove(String _building, String _room) {
    String room = _room;
    String building = _building;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      verticalDirection: VerticalDirection.down,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
            padding: new EdgeInsets.all(8.0),
            child: Text(
              "Wating for Housing Approvement!" +
                  " Request for change to: " +
                  building +
                  " / " +
                  room,
              style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
            )),
        RaisedButton(
            key: null,
            onPressed: () {
              Firestore.instance
                  .collection("Requests")
                  .document("ChangeRoom")
                  .collection("ChangeRoom")
                  .where("requester", isEqualTo: _user.uid)
                  .getDocuments()
                  .then((data) {
                if (!data.documents.isEmpty)
                  data.documents[0].reference.delete().then((a) {
                    Navigator.pop(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RequestsPage()));
                  });
              });
              Firestore.instance
                  .collection("Requests")
                  .document("ChangeRoom")
                  .collection("ChangeRoom")
                  .where("partner", isEqualTo: _user.uid)
                  .getDocuments()
                  .then((data) {
                if (!data.documents.isEmpty)
                  data.documents[0].reference.delete().then((a) {
                    Navigator.pop(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RequestsPage()));
                  });
              });
            },
            color: Colors.red,
            child: new Text(
              "Delete the request",
              style: new TextStyle(
                  fontSize: 17.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w200,
                  fontFamily: "Merriweather"),
            ))
      ],
    );
  }

  waitingPartnerWidget(String _building, String _room) {
    String room = _room;
    String building = _building;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      verticalDirection: VerticalDirection.down,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
            padding: new EdgeInsets.all(8.0),
            child: Text(
              "Partner approvement is required!" +
                  " Request for change to: " +
                  building +
                  " / " +
                  room,
              style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
            )),
        RaisedButton(
            key: null,
            onPressed: () {
              Firestore.instance
                  .collection("Requests")
                  .document("ChangeRoom")
                  .collection("ChangeRoom")
                  .where("requester", isEqualTo: _user.uid)
                  .getDocuments()
                  .then((data) {
                if (!data.documents.isEmpty)
                  data.documents[0].reference.delete().then((a) {
                    Navigator.pop(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RequestsPage()));
                  });
              });
            },
            color: Colors.red,
            child: new Text(
              "Delete the request",
              style: new TextStyle(
                  fontSize: 17.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w200,
                  fontFamily: "Merriweather"),
            ))
      ],
    );
  }

  noRequestPage() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      verticalDirection: VerticalDirection.down,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
            padding: new EdgeInsets.all(8.0),
            child: Text(
              "You have no Requests",
              style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
            )),
        RaisedButton(
            key: null,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RequestChangeRoomList()));
              ;
            },
            color: Colors.red,
            child: new Text(
              "New Request",
              style: new TextStyle(
                  fontSize: 17.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w200,
                  fontFamily: "Merriweather"),
            ))
      ],
    );
  }

  FirebaseUser _user;

  Future<QuerySnapshot> checkRequest() async {
    QuerySnapshot _request;
    await FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      _user = user;
    });

    await Firestore.instance
        .collection('Requests')
        .document("ChangeRoom")
        .collection("ChangeRoom")
        .where('requester', isEqualTo: _user.uid)
        .getDocuments()
        .then((data) {
      if (!data.documents.isEmpty) {
        _request = data;
      }
    });

    await Firestore.instance
        .collection('Requests')
        .document("ChangeRoom")
        .collection("ChangeRoom")
        .where('partner', isEqualTo: _user.uid)
        .getDocuments()
        .then((data) {
      if (!data.documents.isEmpty) {
        _request = data;
      }
    });

    if (_request != null)
      return _request;
    else
      return Firestore.instance
          .collection('Requests')
          .document("ChangeRoom")
          .collection("ChangeRoom")
          .where('partner', isEqualTo: _user.uid)
          .getDocuments();
  }

  @override
  Widget build(BuildContext context) {
//     requestStatusWidget(String _requester, String _partner, String _status) {
//      String requester =  _requester;
//      String partner = _partner;
//      String status = _status;
//      return new FutureBuilder(
//          future: checkRequest(),
//          // a previously-obtained Future<String> or null
//          builder:
//              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {});
//    }

    var futureBuilder = new FutureBuilder<QuerySnapshot>(
      future: checkRequest(), // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return new Text('Press button to start.');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return new Text('Awaiting result...');
          case ConnectionState.done:
            if (snapshot.data.documents.isEmpty)
              return noRequestPage(); //This is if no requests has made
            else {
              if (snapshot.data.documents[0].data['request_status'] ==
                  "approved") //This is when request is finished and approved
                return Text(
                  "Congratulation, your request going to Building/Room: " +
                      snapshot.data.documents[0].data['requested_building'] +
                      " / " +
                      snapshot.data.documents[0].data["requested_room"] +
                      " is approved!",
                  style: TextStyle(fontSize: 18.0),
                );
              else if (snapshot.data.documents[0].data['request_status'] ==
                  "refused") //This is when request is finished and refused
                return Text(
                  "Your request going to Building/Room: " +
                      snapshot.data.documents[0].data['requested_building'] +
                      " / " +
                      snapshot.data.documents[0].data["requested_room"] +
                      " is Refused!",
                  style: TextStyle(fontSize: 18.0),
                );
              else if (snapshot.data.documents[0].data['partner_approve'] ==
                  "approve") //This is when request is completed from residents point of view
                return waitingHousingApprove(
                    snapshot.data.documents[0].data['requested_building'],
                    snapshot.data.documents[0].data["requested_room"]);
              else if (snapshot.data.documents[0].data['requester'] ==
                      _user.uid &&
                  snapshot.data.documents[0].data['partner_approve'] ==
                      "pending") //This is to display waiting for partner approve
                return waitingPartnerWidget(
                    snapshot.data.documents[0].data['requested_building'],
                    snapshot.data.documents[0].data["requested_room"]);
              else
                return partnerApprove(
                    snapshot.data.documents[0].data['requested_building'],
                    snapshot.data.documents[0].data["requested_room"]);
            }
        }
        return null; // unreachable
      },
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("good"),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          verticalDirection: VerticalDirection.down,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 20.0),
              height: 170.0,
              width: double.infinity,
              child: Card(
                child: futureBuilder,
              ),
            )
          ],
        ),
      ),
    );
  }

  Stream<QuerySnapshot> _getRoomData() {
    return Firestore.instance
        .collection('Room')
        .where('room_status', isEqualTo: 'available')
        .snapshots();
  }
}
