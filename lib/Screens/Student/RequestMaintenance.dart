import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'UnlockDoor.dart';

class RequestMaintenance extends StatefulWidget {
  @override
  RequestMaintenanceState createState() => new RequestMaintenanceState();
}

class RequestMaintenanceState extends State<RequestMaintenance> {
  final formKey = GlobalKey<FormState>();

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
                  text: 'My Requests',
                ),
                Tab(
                  text: 'Create New Request',
                ),
              ],
            ),
            title: Text('Maintenance Requests'),
          ),
          body: TabBarView(
            children: [
              Container(),
              Container(
                padding: EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
                child: Form(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      TextFormField(),
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
}
