import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ViewRoom.dart';
import '../Housing/HViewRoom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewBuilding extends StatefulWidget {
  @override
  ViewBuildingState createState() => new ViewBuildingState();

  final String buildingNumber;

  //constructor
  ViewBuilding({
    this.buildingNumber,
  });
}

class ViewBuildingState extends State<ViewBuilding> {
  String uid;
  String role;
  String email;

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) async {
      this.uid = user.uid;
      this.email = user.email;

      await Firestore.instance
          .collection('Users')
          .document(uid)
          .get()
          .then((data) {
        if (data.exists) {
          setState(() {
            role = data['Role'];
          });
        }
      });
    });
    super.initState();
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
                  text: 'First Floor',
                ),
                Tab(
                  text: 'Second Floor',
                ),
                Tab(
                  text: 'Third Floor',
                ),
              ],
            ),
            leading: new IconButton(
              icon: new Icon(
                Icons.arrow_back,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Building ${widget.buildingNumber}',
            ),
          ),
          body: TabBarView(
            children: [
// First Floor
              Container(
                child: ListView(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 30.0),
                      alignment: Alignment.center,
                      child: Stack(
                        children: <Widget>[
                          Image.asset('assets/images/BuldingLayout.jpg'),
                          Positioned(
                            top: 5.0,
                            left: 170.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '101',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '101',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 101'),
                            ),
                          ),
                          Positioned(
                            top: 50.0,
                            left: 170.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '103',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '103',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 103'),
                            ),
                          ),
                          Positioned(
                            top: 90.0,
                            left: 170.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '105',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '105',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 105'),
                            ),
                          ),
                          Positioned(
                            top: 130.0,
                            left: 170.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '107',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '107',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 107'),
                            ),
                          ),
                          Positioned(
                            top: 170.0,
                            left: 170.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                            buildingNumber:
                                                widget.buildingNumber,
                                            roomNumber: '109',
                                          ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                            buildingNumber:
                                                widget.buildingNumber,
                                            roomNumber: '109',
                                          ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 109'),
                            ),
                          ),
                          Positioned(
                            top: 210.0,
                            left: 170.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '111',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '111',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 111'),
                            ),
                          ),
                          Positioned(
                            top: 287.0,
                            left: 170.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '113',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '113',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 113'),
                            ),
                          ),
                          Positioned(
                            top: 327.0,
                            left: 170.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '115',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '115',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 115'),
                            ),
                          ),
                          Positioned(
                            top: 367.0,
                            left: 170.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '117',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '117',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 117'),
                            ),
                          ),
                          Positioned(
                            top: 407.0,
                            left: 170.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '119',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '119',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 119'),
                            ),
                          ),
                          Positioned(
                            top: 447.0,
                            left: 170.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '121',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '121',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 121'),
                            ),
                          ),
                          Positioned(
                            top: 60.0,
                            left: 10.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '102',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '102',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 102'),
                            ),
                          ),
                          Positioned(
                            top: 100.0,
                            left: 10.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '104',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '104',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 104'),
                            ),
                          ),
                          Positioned(
                            top: 140.0,
                            left: 10.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '106',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '106',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 106'),
                            ),
                          ),
                          Positioned(
                            top: 180.0,
                            left: 10.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '108',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '108',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 108'),
                            ),
                          ),
                          Positioned(
                            top: 220.0,
                            left: 10.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '110',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '110',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 110'),
                            ),
                          ),
                          Positioned(
                            top: 307.0,
                            left: 10.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '112',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '112',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 112'),
                            ),
                          ),
                          Positioned(
                            top: 347.0,
                            left: 10.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '114',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '114',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 114'),
                            ),
                          ),
                          Positioned(
                            top: 387.0,
                            left: 10.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '116',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '116',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 116'),
                            ),
                          ),
                          Positioned(
                            top: 427.0,
                            left: 10.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '118',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '118',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 118'),
                            ),
                          ),
                          Positioned(
                            top: 467.0,
                            left: 10.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '120',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '120',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 120'),
                            ),
                          ),
                          Positioned(
                            top: 507.0,
                            left: 10.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '122',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '122',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 122'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

// Second Floor
              Container(
                child: ListView(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 30.0),
                      alignment: Alignment.center,
                      child: Stack(
                        children: <Widget>[
                          Image.asset('assets/images/BuldingLayout.jpg'),
                          Positioned(
                            top: 5.0,
                            left: 170.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '201',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '201',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 201'),
                            ),
                          ),
                          Positioned(
                            top: 50.0,
                            left: 170.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '203',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '203',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 203'),
                            ),
                          ),
                          Positioned(
                            top: 90.0,
                            left: 170.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '205',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '205',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 205'),
                            ),
                          ),
                          Positioned(
                            top: 130.0,
                            left: 170.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '207',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '207',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 207'),
                            ),
                          ),
                          Positioned(
                            top: 170.0,
                            left: 170.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '209',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '209',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 209'),
                            ),
                          ),
                          Positioned(
                            top: 210.0,
                            left: 170.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '211',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '211',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 211'),
                            ),
                          ),
                          Positioned(
                            top: 287.0,
                            left: 170.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '213',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '213',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 213'),
                            ),
                          ),
                          Positioned(
                            top: 327.0,
                            left: 170.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '215',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '215',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 215'),
                            ),
                          ),
                          Positioned(
                            top: 367.0,
                            left: 170.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '217',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '217',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 217'),
                            ),
                          ),
                          Positioned(
                            top: 407.0,
                            left: 170.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '219',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '219',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 219'),
                            ),
                          ),
                          Positioned(
                            top: 447.0,
                            left: 170.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '221',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '221',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 221'),
                            ),
                          ),
                          Positioned(
                            top: 60.0,
                            left: 10.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '202',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '202',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 202'),
                            ),
                          ),
                          Positioned(
                            top: 100.0,
                            left: 10.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '204',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '204',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 204'),
                            ),
                          ),
                          Positioned(
                            top: 140.0,
                            left: 10.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '206',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '206',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 206'),
                            ),
                          ),
                          Positioned(
                            top: 180.0,
                            left: 10.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '208',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '208',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 208'),
                            ),
                          ),
                          Positioned(
                            top: 220.0,
                            left: 10.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '210',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '210',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 210'),
                            ),
                          ),
                          Positioned(
                            top: 307.0,
                            left: 10.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '212',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '212',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 212'),
                            ),
                          ),
                          Positioned(
                            top: 347.0,
                            left: 10.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '214',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '214',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 214'),
                            ),
                          ),
                          Positioned(
                            top: 387.0,
                            left: 10.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '216',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '216',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 216'),
                            ),
                          ),
                          Positioned(
                            top: 427.0,
                            left: 10.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '218',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '218',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 218'),
                            ),
                          ),
                          Positioned(
                            top: 467.0,
                            left: 10.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '220',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '220',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 220'),
                            ),
                          ),
                          Positioned(
                            top: 507.0,
                            left: 10.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '222',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '222',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 222'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

// Third Floor
              Container(
                child: ListView(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 30.0),
                      alignment: Alignment.center,
                      child: Stack(
                        children: <Widget>[
                          Image.asset('assets/images/BuldingLayout.jpg'),
                          Positioned(
                            top: 5.0,
                            left: 170.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '301',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '301',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 301'),
                            ),
                          ),
                          Positioned(
                            top: 50.0,
                            left: 170.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '303',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '303',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 303'),
                            ),
                          ),
                          Positioned(
                            top: 90.0,
                            left: 170.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '305',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '305',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 305'),
                            ),
                          ),
                          Positioned(
                            top: 130.0,
                            left: 170.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '307',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '307',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 307'),
                            ),
                          ),
                          Positioned(
                            top: 170.0,
                            left: 170.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '309',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '309',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 309'),
                            ),
                          ),
                          Positioned(
                            top: 210.0,
                            left: 170.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '311',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '311',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 311'),
                            ),
                          ),
                          Positioned(
                            top: 287.0,
                            left: 170.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '313',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '313',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 313'),
                            ),
                          ),
                          Positioned(
                            top: 327.0,
                            left: 170.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '315',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '315',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 315'),
                            ),
                          ),
                          Positioned(
                            top: 367.0,
                            left: 170.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '317',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '317',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 317'),
                            ),
                          ),
                          Positioned(
                            top: 407.0,
                            left: 170.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '319',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '319',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 319'),
                            ),
                          ),
                          Positioned(
                            top: 447.0,
                            left: 170.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '321',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '321',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 321'),
                            ),
                          ),
                          Positioned(
                            top: 60.0,
                            left: 10.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '302',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '302',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 302'),
                            ),
                          ),
                          Positioned(
                            top: 100.0,
                            left: 10.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '304',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '304',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 304'),
                            ),
                          ),
                          Positioned(
                            top: 140.0,
                            left: 10.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '306',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '306',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 306'),
                            ),
                          ),
                          Positioned(
                            top: 180.0,
                            left: 10.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '308',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '308',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 308'),
                            ),
                          ),
                          Positioned(
                            top: 220.0,
                            left: 10.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '310',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '310',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 310'),
                            ),
                          ),
                          Positioned(
                            top: 307.0,
                            left: 10.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '312',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '312',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 312'),
                            ),
                          ),
                          Positioned(
                            top: 347.0,
                            left: 10.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '314',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '314',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 314'),
                            ),
                          ),
                          Positioned(
                            top: 387.0,
                            left: 10.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '316',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '316',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 316'),
                            ),
                          ),
                          Positioned(
                            top: 427.0,
                            left: 10.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '318',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '318',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 318'),
                            ),
                          ),
                          Positioned(
                            top: 467.0,
                            left: 10.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '320',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '320',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 320'),
                            ),
                          ),
                          Positioned(
                            top: 507.0,
                            left: 10.0,
                            child: FlatButton(
                              onPressed: () {
                                if (role == 'Housing') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '322',
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewRoom(
                                        buildingNumber:
                                        widget.buildingNumber,
                                        roomNumber: '322',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text('Room 322'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
