import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncementsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Announcements List'),
      ),
      body: new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('Announcements').orderBy('Created', descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return new Text('Loading...');
          return new ListView(
            shrinkWrap: true,
            children: snapshot.data.documents.map((DocumentSnapshot document) {
              return new ListTile(
                title: ExpansionTile(
                  title: Text(
                    '${document['Title']}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: <Widget>[
                    Text('${document['Details']}\n\n${document['Created']}'),
                  ],
                ),
                trailing: new Row(

                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                  ],
                ),
                onTap: () {}, // view user detaild TODO
              );
            }).toList(),
          );
        },
      ),

    );
  }

}
