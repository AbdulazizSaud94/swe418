import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Shared/StudentProfile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class HViewRoom extends StatefulWidget {
  @override
  HViewRoomState createState() => new HViewRoomState();
  final String buildingNumber;
  final String roomNumber;

  //constructor
  HViewRoom({
    this.buildingNumber,
    this.roomNumber,
  });
}

class HViewRoomState extends State<HViewRoom> {
  QuerySnapshot doc;
  String uid1;
  String uid2;
  String stuEmail1;
  String stuEmail2;
  String roomStatus;
  var stream;
  bool bol = false;

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) async {
      await Firestore.instance
          .collection('Room')
          .document('${widget.buildingNumber}-${widget.roomNumber}')
          .get()
          .then((data) {
        if (data.exists) {
          setState(() {
            this.uid1 = data['UID1'];
            this.uid2 = data['UID2'];
            this.stuEmail1 = data['Email1'];
            this.stuEmail2 = data['Email2'];
            this.roomStatus = data['room_status'];
            this.bol = true;
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title:
            new Text('Housing B${widget.buildingNumber} R${widget.roomNumber}'),
        centerTitle: true,
      ),
      body: new FutureBuilder<DocumentSnapshot>(
          future: Firestore.instance
              .collection('Room')
              .document('${widget.buildingNumber}-${widget.roomNumber}')
              .get(),
          builder: (context, snapshot) {
            if (!bol) {
              return new Center(
                child: new CircularProgressIndicator(),
              );
            }
            return ListView(
              children: <Widget>[
                SizedBox(
                  height: 25.0,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      ' Room number: ',
                      style: new TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${widget.roomNumber}',
                      style: new TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      ' Building number: ',
                      style: new TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${widget.buildingNumber}',
                      style: new TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      ' Room status: ',
                      style: new TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$roomStatus',
                      style: new TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 35.0,
                ),
                Text(
                  ' Room Occupiers:',
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic,),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      '  Student A: ',
                      style: new TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentProfile(
                                  stuId: uid1,
                                ),
                          ),
                        );
                      },
                      child: Text(
                        '$stuEmail1',
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                          color: Colors.black54,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      '  Student B: ',
                      style: new TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentProfile(
                                  stuId: uid2,
                                ),
                          ),
                        );
                      },
                      child: Text(
                        '$stuEmail2',
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                          color: Colors.black54,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 55,),
                Container(
                  child: Text(' Manage Room:'
                  ,style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 22,
                    ),),
                ),
                SizedBox(height: 9,),
                Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: RaisedButton.icon(
                          icon: Icon(FontAwesomeIcons.userCheck,color:Colors.white, size: 18,),
                          label: Text(' Assign',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),),
                          onPressed: null),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(25, 0, 50, 0),
                      child: RaisedButton.icon(
                          icon: Icon(FontAwesomeIcons.userTimes,color: Colors.white,size: 18,),
                          label: Text(' Remove',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),),
                          onPressed: null),
                    ),

                  ],
                ),
              ],
            );
          }),
    );
  }
}
