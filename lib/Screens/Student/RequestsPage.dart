import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
                            'YOU HAVE',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(25.0, 40.0, 5.0, 25.0),
                          child: Text(
                            '25',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 44.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 70.0),
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
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 40.0),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 3.0,
            mainAxisSpacing: 5.0,
            shrinkWrap: true,
            children: <Widget>[

              buildCard('SingleRoom', 'View and create SingleRoom requests', 2, '/AdminTabs'),
              buildCard('ChangeRoom', 'View and create ChangeRoom requests', 3, '/AdminTabs'),
              buildCard('Pairing', 'View and create Pairing requests', 4, '/AdminTabs'),
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
                      'SingleRoom',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      'View and create SingleRoom requests',
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
                              'SHOW',
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
                              Navigator.of(context).pushReplacementNamed('/AdminTabs');
                            },
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                  margin: EdgeInsets.fromLTRB(25.0, 0.0, 5.0, 10.0)
              ),

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
                        'SingleRoom',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'View and create SingleRoom requests',
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
                                'SHOW',
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
                                Navigator.of(context).pushReplacementNamed('/AdminTabs');
                              },
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  margin: EdgeInsets.fromLTRB(10.0, 0.0, 25.0, 10.0)
              ),
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
                leading: new Icon(Icons.exit_to_app),
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

Widget buildCard(String type, String description, int cardIndex, String route) {
  return Card(
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
              Icons.refresh,
              size: 50.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            type,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            description,
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
                    'SHOW',
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
                    Navigator.of(context).pushReplacementNamed(route);
                  },
                ),
              ),
            );
          }),
        ],
      ),
      margin: cardIndex.isEven
          ? EdgeInsets.fromLTRB(10.0, 0.0, 25.0, 10.0)
          : EdgeInsets.fromLTRB(25.0, 0.0, 5.0, 10.0)
  );
}


