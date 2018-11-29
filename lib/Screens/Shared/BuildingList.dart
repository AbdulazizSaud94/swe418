import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:map_view/map_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'ViewBuilding.dart';


var googleMapsApiKey = 'AIzaSyCKMhiABoRdSTWZ15iwRkhqCwJtShqQZGQ';

class BuildingList extends StatefulWidget {
  BuildingListState createState() => new BuildingListState();
}

class BuildingListState extends State<BuildingList> {
  String uid;
  QuerySnapshot doc;

  MapView mapView = new MapView();
  CameraPosition cameraPosition;
  var staticMapProvider = new StaticMapProvider(googleMapsApiKey);
  Uri staticMapUri;
  Marker markers;

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) async {
      this.uid = user.uid;
      doc = await Firestore.instance.collection('Building').orderBy('building_number', descending: true).getDocuments();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MapView.setApiKey('AIzaSyCKMhiABoRdSTWZ15iwRkhqCwJtShqQZGQ');
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Building List'),
      ),
      body: new StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('Building').orderBy('building_number', descending: false).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return new Center(
                child: new CircularProgressIndicator(),
              );
            return new ListView(shrinkWrap: true, children: <Widget>[
              new ListView(
                shrinkWrap: true,
                children:
                snapshot.data.documents.map((DocumentSnapshot document) {
                  return new ListTile(
                    title: new Text('Building: ${document['building_number']}'),
                    trailing: new Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[

                        Container(
                          width: 50.0,
                          child: new FlatButton(
                            child: Icon(FontAwesomeIcons.building),
                            onPressed: () {
                              print('Building: ');
                              print("${document['building_number']}");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewBuilding(
                                    buildingNumber: document['building_number'],
                                  ),
                                ),
                              );

                            },
                          ),
                        ),

                        Container(
                          width: 50.0,
                          child: new FlatButton(
                            child: Icon(Icons.place),
                            onPressed: () {
                              print('reeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
                              print("${document['lat']}, ${document['lng']}");
                              markers = new Marker(
                                  '0',
                                  'Building ${document['building_number']}',
                                  document['lat'],
                                  document['lng'],
                                  color: Colors.red);
                              showMap(document);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ]);
          }),
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
                leading: new Icon(FontAwesomeIcons.externalLinkAlt),
                title: new Text('Requests Page'),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/RequestsPage');
                }),
            new ListTile(
                leading: new Icon(Icons.library_books),
                title: new Text('Your Contract'),
                onTap: () {
                  Navigator.of(context).pushNamed('/RoomContract');
                }),
            new ListTile(
                leading: new Icon(FontAwesomeIcons.user),
                title: new Text('Profile'),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/RequestsPage');
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

  showMap(DocumentSnapshot document) {
    mapView.show(
      new MapOptions(
          mapViewType: MapViewType.normal,
          initialCameraPosition:
          CameraPosition(Location(document['lat'], document['lng']), 16.0),
          showMyLocationButton: true,
          showUserLocation: true,
          title: "Building ${document['building_number']}"),

    );
    mapView.centerLocation;
    mapView.onMapReady.listen((_) {
      mapView.addMarker(markers);

    });
    mapView.dismiss();

  }
}
