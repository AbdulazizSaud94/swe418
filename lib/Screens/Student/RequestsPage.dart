import 'package:flutter/material.dart';

class RequestsPage extends StatefulWidget{
  @override
  RequestsPageState createState() => new RequestsPageState();
}

class RequestsPageState extends State<RequestsPage>{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
                alignment: Alignment(0.0, ),
                color: Colors.white,
                child: Text(
                  'My Requests',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: new Drawer(),
    );

  }
}