import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'HSwapRequest.dart';

class HSwapList extends StatefulWidget {
  HSwapListState createState() => new HSwapListState();
}

class HSwapListState extends State<HSwapList> {
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
                ),
              ],
            ),
            title: Text(
              'Swap Room Requests',
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
                      child: Text('Pending Rquests:',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,)),
                    ),
                    SizedBox(height: 15.0),
                    new StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection('Requests')
                          .document("SwapRoom")
                          .collection("SwapRoom")
                          .where("ReceiverApproval", isEqualTo: "Approved")
                          .where("HousingApproval", isEqualTo: "Pending")
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) return new Text('Loading...');
                        if (snapshot.data.documents.isNotEmpty) {
                          return new ListView(
                            shrinkWrap: true,
                            children: snapshot.data.documents
                                .map((DocumentSnapshot document) {
                              return new ExpansionTile(
                                title: new Text(
                                    'Sender: ${document['Sender']}\nReceiver: ${document['Receiver']}'),
                                children: <Widget>[
                                  new Text(
                                      'Sent: ${document['Sent'].toString()}'),
                                ],
                                trailing: new Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Container(
                                      width: 50.0,
                                      child: new FlatButton(
                                        child: Icon(
                                            FontAwesomeIcons.solidCheckSquare),
                                        textColor: Colors.grey,
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  HSwapRequest(
                                                    senderID:
                                                        '${document['SenderUID']}',
                                                    receiverID:
                                                        '${document['ReceiverUID']}',
                                                    senderBuilding:
                                                        '${document['SenderBuilding']}',
                                                    senderRoom:
                                                        '${document['SenderRoom']}',
                                                    receiverBuilding:
                                                        '${document['ReceiverBuilding']}',
                                                    receiverRoom:
                                                        '${document['ReceiverRoom']}',
                                                    senderEmail:
                                                        '${document['Sender']}',
                                                    receiverEmail:
                                                        '${document['Receiver']}',
                                                    sent: '${document['Sent']}',
                                                    senderPosition:
                                                        '${document['SenderPosition']}',
                                                    receiverPosition:
                                                        '${document['ReceiverPosition']}',
                                                    requestID:
                                                        document.documentID,
                                                  ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    new Container(
                                      width: 50.0,
                                      child: new FlatButton(
                                        child: Icon(
                                            FontAwesomeIcons.solidWindowClose),
                                        textColor: Colors.grey,
                                        onPressed: () {
                                          _handlePressedReject(
                                              context, document);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        } else {
                          return new Text('  No Requests Found');
                        }
                      },
                    ),
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
                            .document("SwapRoom")
                            .collection("SwapRoom")
                            .where("ReceiverApproval", isEqualTo: "Approved")
                            .where("HousingApproval", isEqualTo: "Approved")
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) return new Text('Loading...');
                          if (snapshot.data.documents.isNotEmpty) {
                            return new ListView(
                              shrinkWrap: true,
                              children: snapshot.data.documents
                                  .map((DocumentSnapshot document) {
                                return new ExpansionTile(
                                  title: new Text(
                                      'Sender: ${document['Sender']}\nReceiver: ${document['Receiver']}'),
                                  children: <Widget>[
                                    new Text(
                                        'Status: ${document['HousingApproval'].toString()}'),
                                    new Text(
                                        'Sent: ${document['Sent'].toString()}'),
                                  ],
                                  trailing: new Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[],
                                  ),
                                );
                              }).toList(),
                            );
                          } else {
                            return new Text('  No Requests Found');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
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
                            .document("SwapRoom")
                            .collection("SwapRoom")
                            .where("ReceiverApproval", isEqualTo: "Approved")
                            .where("HousingApproval", isEqualTo: "Rejected")
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) return new Text('Loading...');
                          if (snapshot.data.documents.isNotEmpty) {
                            return new ListView(
                              shrinkWrap: true,
                              children: snapshot.data.documents
                                  .map((DocumentSnapshot document) {
                                return new ExpansionTile(
                                  title: new Text(
                                      'Sender: ${document['Sender']}\nReceiver: ${document['Receiver']}'),
                                  children: <Widget>[
                                    new Text(
                                        'Status: ${document['HousingApproval'].toString()}'),
                                    new Text(
                                        'Sent: ${document['Sent'].toString()}'),
                                  ],
                                  trailing: new Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Container(
                                        width: 50.0,
                                        child: new FlatButton(
                                          child: Icon(FontAwesomeIcons
                                              .solidCheckSquare),
                                          textColor: Colors.grey,
                                          onPressed: () {},
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                          } else {
                            return new Text('  No Requests Found');
                          }
                        },
                      ),
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

  void _handlePressedReject(BuildContext context, DocumentSnapshot document) {
    confirmDialogReject(context).then((bool value) async {
      if (value) {
        Firestore.instance.runTransaction((transaction) async {
          DocumentSnapshot ds = await transaction.get(document.reference);
          await transaction
              .update(ds.reference, {'HousingApproval': 'Rejected'});
          _showToast(context, "Request is rejected!");
        });
      }
    });
  }
}

Future<bool> confirmDialogReject(BuildContext context) {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text("Reject request?"),
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
