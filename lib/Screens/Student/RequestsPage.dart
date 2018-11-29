import 'dart:async';
import 'change_room_request.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'UnlockDoor.dart';
import 'Notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RequestsPage extends StatefulWidget {
  @override
  RequestsPageState createState() => new RequestsPageState();
}

class RequestsPageState extends State<RequestsPage> {
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
                height: 100.0,
                color: Colors.white,
                alignment: Alignment(0.0, -0.40),
                child: Text(
                  'My Requests',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(25.0, 65.0, 25.0, 0.0),
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
                          padding: EdgeInsets.fromLTRB(25.0, 25.0, 5.0, 5.0),
                          child: Text(
                            'YOUR',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(25.0, 40.0, 5.0, 10.0),
                          child: Text(
                            'Notifications',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 10.0),
                    Container(
                      height: 50.0,
                      width: 135.0,
                      child: RaisedButton(
                        child: const Text(
                          'SHOW ALL',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        color: Colors.green,
                        splashColor: Colors.blueGrey,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotificationPage()));
                        },
                      ),
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
                        'View and create \nSwap requests',
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
                                Navigator.of(context).pushNamed('/SwapRequest');
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
                        'View and create \nPairing requests',
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
                                 Navigator.of(context).pushNamed('/RequestPairing');
                            }
                            ),
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
                        'View and create \nSingle Room requests',
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
                                Navigator.of(context).pushNamed('/SingleRoomRequestPage');
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
                        'View and create \nChange Room requests',
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
                               Navigator.of(context).pushNamed('/ChangeRoomPage');
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
                        'View and create \nMaintenance requests',
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
                                    .pushNamed('/RequestMaintenance');
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
                        'View and create \nDoor Unlock requests',
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
                                    .pushNamed('/UnlockDoorList');
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
                leading: new Icon(FontAwesomeIcons.bullhorn),
                title: new Text('Announcements List'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed('/AnnouncementsList');
                }),
            new ListTile(
                leading: new Icon(FontAwesomeIcons.user),
                title: new Text('Profile'),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/ProfilePage');
                }),
            new ListTile(
                leading: new Icon(Icons.library_books),
                title: new Text('Your Contract'),
                onTap: () {
                  Navigator.of(context).pushNamed('/RoomContract');
                }),
            new ListTile(
                leading: new Icon(FontAwesomeIcons.building),
                title: new Text('Building List'),
                onTap: () {
                  Navigator.of(context).pushNamed('/BuildingList');
                }),
            new ListTile(
                leading: new Icon(FontAwesomeIcons.mailchimp),
                title: new Text('Posts'),
                onTap: () {
                  Navigator.of(context).pushNamed('/PostPage');
                }),
            new ListTile(
                leading: new Icon(Icons.pan_tool),
                title: new Text('Complaints'),
                onTap: () {
                  Navigator.of(context).pushNamed('/Complaints');
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
Future<bool> confirmDialog(BuildContext context){
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return new AlertDialog(
        title: new Text("Pairing Requests"),
        actions: <Widget>[
          new FlatButton(
            child: Text("Recieved"),
            onPressed:() => Navigator.of(context).pop(true),
          ),
          new FlatButton(
            child: Text("Send new Request"),
            onPressed:() => Navigator.of(context).pop(false),
          ),
        ],
      );
    }
  );}