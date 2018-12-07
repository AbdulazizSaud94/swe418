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
  bool bol = false;

  MapView mapView = new MapView();
  CameraPosition cameraPosition;
  var staticMapProvider = new StaticMapProvider(googleMapsApiKey);
  Uri staticMapUri;
  Marker markers;

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) async {
      this.uid = user.uid;
      doc = await Firestore.instance
          .collection('Building')
          .orderBy('building_number', descending: true)
          .getDocuments();

      await Firestore.instance
          .collection('Users')
          .document(uid)
          .get()
          .then((data) {
        if (data.exists) {
          setState(() {
            this.bol = true;
          });
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MapView.setApiKey('AIzaSyCKMhiABoRdSTWZ15iwRkhqCwJtShqQZGQ');
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Building List'),
        leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/RequestsPage');
            }),
      ),
      body: new StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('Building')
              .orderBy('building_number', descending: false)
              .snapshots(),
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
                                        buildingNumber:
                                            document['building_number'],
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
