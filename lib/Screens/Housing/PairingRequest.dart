import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PairingRequest extends StatefulWidget {
  PairingRequestState createState() => new PairingRequestState();
}

class PairingRequestState extends State<PairingRequest> {

  @override
  void _showToast(BuildContext context, String message) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  text: 'Pending',
                ),
                Tab(
                  text: 'Approved',
                ),
                Tab(
                  text: 'Declined',
                )
              ],
            ),
            title: Text(
              'Pairing Requests',
            ),
            centerTitle: true,
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
                      child: Text('Pending Requests: ',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,)),
                    ),
                    SizedBox(height: 15.0),
                    new StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection('Requests')
                            .document('Pairing')
                            .collection('PairingRequests')
                            .where('HousingApproval', isEqualTo:'Pending')
                            .where('ReceiverApproval', isEqualTo: 'Approved')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return new Center(
                              child: new CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.data.documents.isNotEmpty) {
                            return new ListView(shrinkWrap: true, children: <
                                Widget>[
                              new ListView(
                                shrinkWrap: true,
                                children: snapshot.data.documents
                                    .map((DocumentSnapshot document) {
                                  return new ListTile(
                                      title: new Text(
                                          'Student1: ${document['Sender'].toString()}'+
                                          '\nStudent2: ${document['Receiver'].toString()}'),
                                      trailing: new Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            new Container(
                                              width: 50.0,
                                              child: new FlatButton(
                                                child: Icon(Icons.done),
                                                textColor: Colors.blueAccent,
                                                onPressed: () async {
                                                  _handlePressed(context,
                                                      document, "Approve");
                                                  var token, token2;
                                                  await Firestore.instance
                                                      .collection("Users")
                                                      .document(document[
                                                          'SenderUID'])
                                                      .get()
                                                      .then((data) {
                                                    token = data.data['token'];
                                                  });
                                                  await Firestore.instance
                                                      .collection("Users")
                                                      .document(document[
                                                          'ReceiverUID'])
                                                      .get()
                                                      .then((data) {
                                                    token2 = data.data['token'];
                                                  });
                                                  await Firestore.instance
                                                      .collection(
                                                          "Notifications")
                                                      .add({
                                                    "date": new DateTime.now(),
                                                    "message":
                                                        "Your request is approved!",
                                                    "title":
                                                        "Request to change room",
                                                    "sender":
                                                        "Housing department",
                                                    "to_token": token,
                                                    "reciever":
                                                        document['SenderUID']
                                                  });

                                                  _showToast(context,
                                                      "Request is approved successfully!");
                                                  await Firestore.instance
                                                      .collection(
                                                          "Notifications")
                                                      .add({
                                                    "date": new DateTime.now(),
                                                    "message":
                                                        "Your request is approved!",
                                                    "title": "Pairing request",
                                                    "sender":
                                                        "Housing department",
                                                    "to_token": token2,
                                                    "reciever":
                                                        document['ReceiverUID']
                                                  });
                                                },
                                              ),
                                            ),
                                            new Container(
                                              width: 50.0,
                                              child: new FlatButton(
                                                child: Icon(Icons.remove),
                                                textColor: Colors.blueAccent,
                                                onPressed: () async {
                                                  _handlePressed(context,
                                                      document, "Decline");
                                                  var token, token2;
                                                  await Firestore.instance
                                                      .collection("Users")
                                                      .document(document[
                                                          'SenderUID'])
                                                      .get()
                                                      .then((data) {
                                                    token = data.data['token'];
                                                  });
                                                  await Firestore.instance
                                                      .collection("Users")
                                                      .document(document[
                                                          'ReceiverUID'])
                                                      .get()
                                                      .then((data) {
                                                    token2 = data.data['token'];
                                                  });
                                                  await Firestore.instance
                                                      .collection(
                                                          "Notifications")
                                                      .add({
                                                    "date": new DateTime.now(),
                                                    "message":
                                                        "Your request is declined!",
                                                    "title":
                                                        "Request to change room",
                                                    "sender":
                                                        "Housing department",
                                                    "to_token": token,
                                                    "reciever":
                                                        document['SenderUID']
                                                  });
                                                  await Firestore.instance
                                                      .collection(
                                                          "Notifications")
                                                      .add({
                                                    "date": new DateTime.now(),
                                                    "message":
                                                        "Your request is declined!",
                                                    "title": "Pairing request",
                                                    "sender":
                                                        "Housing department",
                                                    "to_token": token2,
                                                    "reciever":
                                                        document['ReceiverUID']
                                                  });

                                                  _showToast(context,
                                                      "Request is declined successfully!");
                                                },
                                              ),
                                            ),
                                          ]));
                                }).toList(),
                              ),
                            ]);
                          } else {
                            return new Text('  No Requests Found');
                          }
                        }),
                  ],
                ),
              ),
              //Second tab
              Container(
                padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                child: new Form(
                  child: new ListView(
                    children: <Widget>[
                      Text(
                        'Approved Requests:',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15.0),
                      new StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection('Requests')
                              .document('Pairing')
                              .collection('PairingRequests')
                              .where('HousingApproval', isEqualTo: 'Approved')
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData)
                              return new Center(
                                child: new CircularProgressIndicator(),
                              );
                            if (snapshot.data.documents.isNotEmpty) {
                              return new ListView(
                                  shrinkWrap: true,
                                  children: <Widget>[
                                    new ListView(
                                      shrinkWrap: true,
                                      children: snapshot.data.documents
                                          .map((DocumentSnapshot document) {
                                        return new ExpansionTile(
                                          title: new Text(
                                              'Student 1: ${document['Sender']} \nStudent 2: ${document['Receiver']}'),
                                          children: <Widget>[
                                            new Text(
                                                'Status: ${document['HousingApproval']}'),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ]);
                            } else {
                              return new Text('  No Requests Found');
                            }
                          }),
                    ],
                  ),
                ),
              ),
              //3rd tab
              Container(
                padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                child: new Form(
                  child: new ListView(
                    children: <Widget>[
                      Text(
                        'Declined Requests:',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15.0),
                      new StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection('Requests')
                              .document('Pairing')
                              .collection('PairingRequests')
                              .where('HousingApproval', isEqualTo: 'Declined')
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData)
                              return new Center(
                                child: new CircularProgressIndicator(),
                              );
                            if (snapshot.data.documents.isNotEmpty) {
                              return new ListView(
                                  shrinkWrap: true,
                                  children: <Widget>[
                                    new ListView(
                                      shrinkWrap: true,
                                      children: snapshot.data.documents
                                          .map((DocumentSnapshot document) {
                                        return new ExpansionTile(
                                          title: new Text(
                                              'Student 1: ${document['Sender']}\nStudent 2: ${document['Receiver']}'),
                                          children: <Widget>[
                                            new Text(
                                                'Status: ${document['HousingApproval']}'),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ]);
                            } else {
                              return new Text('  No Requests Found');
                            }
                          }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handlePressed(
      BuildContext context, DocumentSnapshot document, String check) async {
    if (check.contains('Decline')) {
      Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot ds = await transaction.get(document.reference);
        await transaction.update(ds.reference, {'HousingApproval': 'Declined'});
      });
    }
    if (check.contains('Approve')) {

      Firestore.instance
      .collection('Users')
      .document(document['SenderUID'])
      .updateData({'Status':'paired'});

      Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot ds = await transaction.get(document.reference);
        await transaction.update(ds.reference, {'HousingApproval': 'Approved'});

                   if(document['ReceiverPosition']=='A'){
                     Firestore.instance
                  .collection('Room')
                  .document('${document['ReceiverBuilding']}-${document['ReceiverRoom']}')
                  .updateData({'Email2': document['Sender'], 'UID2':document['SenderUID'], 'room_status': 'Full'});

                      Firestore.instance
                  .collection('Users')
                  .document(document['SenderUID'])
                  .updateData({'Building': document['ReceiverBuilding'], 'Room': document['ReceiverRoom'], 'Position': 'B','Status':'paired'});

                     if(document['SenderPosition']=='A'){
                       Firestore.instance
                           .collection('Room')
                           .document('${document['SenderBuilding']}-${document['SenderRoom']}')
                           .updateData({'Email1': '0', 'UID1':'0',  'room_status': 'Vacant'});
                     }else{
                       Firestore.instance
                           .collection('Room')
                           .document('${document['SenderBuilding']}-${document['SenderRoom']}')
                           .updateData({'Email2': '0', 'UID2':'0', 'room_status': 'Vacant'});
                     }


                   }
                   else{
                     Firestore.instance
                  .collection('Room')
                  .document('${document['ReceiverBuilding']}-${document['ReceiverRoom']}')
                  .updateData({'Email1': document['Sender'], 'UID1':document['SenderUID'], 'room_status': 'Full'});

                  Firestore.instance
                  .collection('Users')
                  .document(document['SenderUID'])
                  .updateData({'Building': document['ReceiverBuilding'], 'Room': document['ReceiverRoom'],'Position': 'A','Status':'paired'});

                     if(document['SenderPosition']=='A'){
                       Firestore.instance
                           .collection('Room')
                           .document('${document['SenderBuilding']}-${document['SenderRoom']}')
                           .updateData({'Email1': '0', 'UID1':'0',  'room_status': 'Vacant'});
                     }else{
                       Firestore.instance
                           .collection('Room')
                           .document('${document['SenderBuilding']}-${document['SenderRoom']}')
                           .updateData({'Email2': 'empty', 'UID2':'0', 'room_status': 'Vacant'});
                     }
                   }
      });
    }
  }
}

Future<bool> confirmDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text("Mark This As Done?"),
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
