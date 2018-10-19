import "package:flutter/material.dart";
import 'package:map_view/map_view.dart';

var googleMapsApiKey = 'AIzaSyCKMhiABoRdSTWZ15iwRkhqCwJtShqQZGQ';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => new _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapView mapView = new MapView();
  CameraPosition cameraPosition;
  var staticMapProvider = new StaticMapProvider(googleMapsApiKey);
  Uri staticMapUri;
  List<Marker> markers = <Marker>[
    new Marker('1', 'KFUPM', 26.307079, 50.145940, color: Colors.green)
  ];
  showMap() {}

  @override
  void initState() {
    super.initState();
    cameraPosition = new CameraPosition(Location(26.306999, 50.145893), 10.0);
    staticMapUri = staticMapProvider.getStaticUri(
        Location(26.306999, 50.145893), 15,
        height: 400, width: 900, mapType: StaticMapViewType.roadmap);
  }

  @override
  Widget build(BuildContext context) {
    MapView.setApiKey(googleMapsApiKey);
    return new Scaffold(
      appBar: AppBar(
        title: Text("Google Maps"),
      ),
      body: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Container(
                height: 300.0,
                child: new Stack(children: <Widget>[
                  new Center(
                    child: new Container(
                        child: Text(
                          "Maps here",
                          textAlign: TextAlign.center,
                        ),
                        padding: const EdgeInsets.all(20.0)),
                  ),
                  new InkWell(
                    child: new Center(
                      child: new Image.network(staticMapUri.toString()),
                    ),
                    onTap: () {
                      mapView.show(
                        new MapOptions(
                            mapViewType: MapViewType.normal,
                            initialCameraPosition: CameraPosition(
                                Location(26.307079, 50.145940), 15.0),
                            showMyLocationButton: true,
                            title: "This is KFUPM"),
                      );
                      mapView.onMapTapped.listen((_) {
                        setState(() {
                          mapView.setMarkers(markers);
                          mapView.zoomToFit(padding: 100);
                        });
                      });
                    },
                  ),
                ])),
            new Container(
              padding: new EdgeInsets.only(top: 10.0),
              child: new Text("Tap To Intract",
                  style: new TextStyle(fontWeight: FontWeight.bold)),
            ),
            new Container(
              padding: new EdgeInsets.only(top: 25.0),
              child: new Text(
                  "Camera Postion: \n\nLat: ${cameraPosition.center.latitude}\n\nLng: ${cameraPosition.center.longitude}\n\nZoom: ${cameraPosition.zoom}"),
            )
          ]),
    );
  }
}
