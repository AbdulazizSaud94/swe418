import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Shared/StudentProfile.dart';
import 'RemoveStudent.dart';
import 'AssignStudent.dart';
import '../Shared/ViewBuilding.dart';
import 'ChangeRoomStatus.dart';

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
        leading: new IconButton(
          icon: new Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewBuilding(
                buildingNumber: widget.buildingNumber,
              ),
            ),
          ),
        ),
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
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
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
                        if(stuEmail1 == 'empty'){}
                        else{
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentProfile(
                                  stuId: uid1,
                                ),
                          ),
                        );}
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
                        if (stuEmail2 == 'empty') {
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentProfile(
                                    stuId: uid2,
                                  ),
                            ),
                          );
                        }
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
                SizedBox(
                  height: 55,
                ),
                Container(
                  child: Text(
                    ' Manage Room:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 22,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      height: 35,
                      width: 150,
                      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: RaisedButton.icon(
                          icon: Icon(
                            FontAwesomeIcons.userCheck,
                            color: Colors.black87,
                            size: 18,
                          ),
                          label: Text(
                            ' Assign',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                          onPressed: () {
                            if( roomStatus == 'Full'){
                              final snackBar = SnackBar(
                                content: Text(
                                  'Error, this room status is Full!',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              );
                              // Find the Scaffold in the Widget tree and use it to show a SnackBar!
                              Scaffold.of(context)
                                  .showSnackBar(snackBar);
                            }
                            else if(roomStatus == 'Single'){
                              final snackBar = SnackBar(
                                content: Text(
                                  'Error, this room satatus is Single!',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              );
                              // Find the Scaffold in the Widget tree and use it to show a SnackBar!
                              Scaffold.of(context)
                                  .showSnackBar(snackBar);
                            }
                            else{
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AssignStudent(
                                    stuIDA: uid1,
                                    stuIdB: uid2,
                                    buildingNumber: widget.buildingNumber,
                                    roomNumber: widget.roomNumber,
                                  ),
                                ),
                              );}

                          }),
                    ),

                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: <Widget>[
                    Container(
                      height: 35,
                      width: 150,
                      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: RaisedButton.icon(
                          icon: Icon(
                            FontAwesomeIcons.userTimes,
                            color: Colors.black87,
                            size: 18,
                          ),
                          label: Text(
                            ' Remove',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                          onPressed: () {
                            if(uid1 == '0' && uid2 == '0'){
                              final snackBar = SnackBar(
                                content: Text(
                                  'Error, this room is already empty!',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  ),
                                ),
                              );
                              // Find the Scaffold in the Widget tree and use it to show a SnackBar!
                              Scaffold.of(context)
                                  .showSnackBar(snackBar);
                            }
                            else{
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RemoveStudent(
                                    stuIDA: uid1,
                                    stuIdB: uid2,
                                    emailA: stuEmail1,
                                    emailB: stuEmail2,
                                    buildingNumber: widget.buildingNumber,
                                    roomNumber: widget.roomNumber,
                                  ),
                                ),
                              );}
                          }),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: <Widget>[
                    Container(
                      height: 35,
                      width: 150,
                      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: RaisedButton.icon(
                          icon: Icon(
                            FontAwesomeIcons.usersCog,
                            color: Colors.black87,
                            size: 20,
                          ),
                          label: Text(
                            ' Status',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangeRoomStatus(
                                  stuIDA: uid1,
                                  stuIdB: uid2,
                                  buildingNumber: widget.buildingNumber,
                                  roomNumber: widget.roomNumber,
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ],
            );
          }),
    );
  }
}
