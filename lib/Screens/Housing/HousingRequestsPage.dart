import 'dart:async';
import 'housing_change_room_request.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HousingRequestsPage extends StatefulWidget {
  @override
  RequestsPageState createState() => new RequestsPageState();
}

class RequestsPageState extends State<HousingRequestsPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Requests',
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(25.0, 35.0, 25.0, 0.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3.0,
                        color: Colors.grey,
                      ),
                    ]),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(76.0, 10.0, 0.0, 10.0),
                          child: Text(
                            'Students Requests',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 40.0),
          GridView.count(
            physics: ScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 3.0,
            mainAxisSpacing: 5.0,
            shrinkWrap: true,
            children: <Widget>[
//1 Swap request
              Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 7.0,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 12.0),
                      Container(
                        height: 60.0,
                        width: 60.0,
                        child: new Icon(
                          Icons.swap_horiz,
                          size: 50.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'SWAP',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'View and Process \nSwap requests',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 15.0),
                      new Builder(builder: (BuildContext context) {
                        return Expanded(
                          child: Container(
                            width: 175.0,
                            child: RaisedButton(
                              child: const Text(
                                'ENTER',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              color: Colors.green,
                              splashColor: Colors.blueGrey,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.only(
                                    bottomRight: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0)),
                              ),
                              onPressed: () {
                                Navigator.of(context).pushNamed('/HSwapList');
                              },
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  margin: EdgeInsets.fromLTRB(10.0, 0.0, 25.0, 10.0)),

//2 Pairing request
              Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 7.0,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 12.0),
                      Container(
                        height: 60.0,
                        width: 60.0,
                        child: new Icon(
                          Icons.group,
                          size: 50.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Pairing',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'View and Process \nPairing requests',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 15.0),
                      new Builder(builder: (BuildContext context) {
                        return Expanded(
                          child: Container(
                            width: 175.0,
                            child: RaisedButton(
                                child: const Text(
                                  'ENTER',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                color: Colors.green,
                                splashColor: Colors.blueGrey,
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.only(
                                      bottomRight: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(10.0)),
                                ),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed('/PairingRequest');
                                }),
                          ),
                        );
                      }),
                    ],
                  ),
                  margin: EdgeInsets.fromLTRB(25.0, 0.0, 5.0, 10.0)),

//3 Single Room request
              Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 7.0,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 12.0),
                      Container(
                        height: 60.0,
                        width: 60.0,
                        child: new Icon(
                          Icons.accessibility,
                          size: 50.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Single Room',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'View and Process \nSingle Room requests',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 15.0),
                      new Builder(builder: (BuildContext context) {
                        return Expanded(
                          child: Container(
                            width: 175.0,
                            child: RaisedButton(
                              child: const Text(
                                'ENTER',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              color: Colors.green,
                              splashColor: Colors.blueGrey,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.only(
                                    bottomRight: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0)),
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed('/SingleRoomRequestList');
                              },
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  margin: EdgeInsets.fromLTRB(10.0, 0.0, 25.0, 10.0)),

//4 Change Room request
              Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 7.0,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 12.0),
                      Container(
                        height: 60.0,
                        width: 60.0,
                        child: new Icon(
                          Icons.card_travel,
                          size: 50.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Change Room',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'View and Process \nChange Room requests',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 15.0),
                      new Builder(builder: (BuildContext context) {
                        return Expanded(
                          child: Container(
                            width: 175.0,
                            child: RaisedButton(
                              child: const Text(
                                'ENTER',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              color: Colors.green,
                              splashColor: Colors.blueGrey,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.only(
                                    bottomRight: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0)),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            HousingChangeRoomPage()));
                                //TODO
                              },
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  margin: EdgeInsets.fromLTRB(25.0, 0.0, 5.0, 10.0)),

//5 Maintenance request
              Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 7.0,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 12.0),
                      Container(
                        height: 60.0,
                        width: 60.0,
                        child: new Icon(
                          Icons.build,
                          size: 50.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Maintenance',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'View and Process \nMaintenance requests',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 15.0),
                      new Builder(builder: (BuildContext context) {
                        return Expanded(
                          child: Container(
                            width: 175.0,
                            child: RaisedButton(
                              child: const Text(
                                'ENTER',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              color: Colors.green,
                              splashColor: Colors.blueGrey,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.only(
                                    bottomRight: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0)),
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed('/HMaintenanceList');
                              },
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  margin: EdgeInsets.fromLTRB(10.0, 0.0, 25.0, 10.0)),

//6 Door unlock request
              Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 7.0,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 12.0),
                      Container(
                        height: 60.0,
                        width: 60.0,
                        child: new Icon(
                          Icons.lock_open,
                          size: 50.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Door Unlock',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'View and Process \nDoor Unlock requests',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 15.0),
                      new Builder(builder: (BuildContext context) {
                        return Expanded(
                          child: Container(
                            width: 175.0,
                            child: RaisedButton(
                              child: const Text(
                                'ENTER',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              color: Colors.green,
                              splashColor: Colors.blueGrey,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.only(
                                    bottomRight: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0)),
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed('/HUnlockDoorList');
                              },
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  margin: EdgeInsets.fromLTRB(25.0, 0.0, 5.0, 10.0)),
            ],
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
                  color: Colors.white30,
                ),
                child: new Center(
                  child: Image.asset('assets/images/System Logo.png',width: 260,),
                ),
              ),
            ),
            new Divider(),
            new ListTile(
                leading: new Icon(Icons.announcement),
                title: new Text('Announcements'),
                onTap: () {
                  Navigator.of(context).pushNamed('/HAnnouncements');
                }),
            new ListTile(
                leading: new Icon(Icons.pan_tool),
                title: new Text('Complaints'),
                onTap: () {
                  Navigator.of(context).pushNamed('/HComplaintsList');
                }),
            new ListTile(
                leading: new Icon(FontAwesomeIcons.fileSignature),
                title: new Text('Inspections'),
                onTap: () {
                  Navigator.of(context).pushNamed('/InspectionForm');
                }),
            new ListTile(
                leading: new Icon(FontAwesomeIcons.building),
                title: new Text('Building List'),
                onTap: () {
                  Navigator.of(context).pushNamed('/HBuildingList');
                }),
            new ListTile(
                leading: new Icon(Icons.vpn_key),
                title: new Text('Master Keys'),
                onTap: () {
                  Navigator.of(context).pushNamed('/HKeyList');
                }),
            new ListTile(
                leading: new Icon(FontAwesomeIcons.signOutAlt),
                title: new Text('Sign Out'),
                onTap: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    Navigator.of(context).pushReplacementNamed('/LoginPage');
                  }).catchError((e) {
                    print(e);
                  });
                }),
          ],
        ),
      ),
    );
  }
}

Future<bool> confirmDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text("Pairing Requests"),
          actions: <Widget>[
            new FlatButton(
              child: Text("Recieved"),
              onPressed: () => Navigator.of(context).pop(true),
            ),
            new FlatButton(
              child: Text("Send new Request"),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ],
        );
      });
}
