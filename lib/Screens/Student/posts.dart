import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ProfilePage.dart';
import 'RequestsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class NewCommentPage extends StatefulWidget {
  DocumentSnapshot post_id;
  NewCommentPage(DocumentSnapshot d){
    post_id = d;
  }
  @override
  _NewCommentPage createState() => new _NewCommentPage(post_id);
}

class _NewCommentPage extends State<NewCommentPage> {
  final myController = TextEditingController();
  final myController2 = TextEditingController();
  DocumentSnapshot post_id;
  _NewCommentPage(DocumentSnapshot d ){
    post_id = d;
  }
  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myController2.dispose();
    super.dispose();
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content:  Text(message),
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  Widget build(BuildContext context) {
    Widget allcards;
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
            'New Post',
          ),
        ),
        body: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                new TextField(
                  controller: myController2,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'Your Text'),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
                new RaisedButton(
                  child: const Text('Add'),
                  color: Theme.of(context).accentColor,
                  elevation: 4.0,
                  splashColor: Colors.blueGrey,
                  onPressed: () async {
                    var uid, creator;
                    String token, x = post_id['uid'];
                    await FirebaseAuth.instance
                        .currentUser()
                        .then((FirebaseUser user) {
                      uid = user.uid;
                    });
                    await Firestore.instance
                        .collection('Users')
                        .document(uid)
                        .get()
                        .then((data) {
                      creator = data.data['Name'];
                    });
                    await Firestore.instance.collection("Comments").add({
                      "text": myController2.text,
                      "date": new DateTime.now(),
                      "name": creator,
                      'post_id': post_id.documentID
                    });
                    await Firestore.instance.collection("Users").document(x).get().then((data) {
                      token = data.data['token'];
                    });
                    await Firestore.instance.collection("Notifications").add({
                      "date": new DateTime.now(),
                      "message":myController2.text,
                      "title": "Reply from "+ creator,
                      "sender": "" + creator,
                      "to_token": token,
                    }).then((a){var b; });
                    _showToast(context, "The comment is added successfully!");
                    Navigator.pop(context,
                        MaterialPageRoute(builder: (context) => Comments(post_id)));
                  },
                ),
              ],
            )
          ],
        ));
  }
}


class Comments extends StatefulWidget {
  @override
  DocumentSnapshot s;

  Comments(DocumentSnapshot id) {
    s = id;
  }

  _Comments createState() => new _Comments(s);
}

class _Comments extends State<Comments> {
  DocumentSnapshot postId;

  Widget getAllPosts() {
    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('Comments').where("post_id", isEqualTo: postId.documentID).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return new Text('Loading...');
          else
            return new ListView(
              children:
              snapshot.data.documents.map((DocumentSnapshot document) {
                return new Container(
                  child: new Column(
                    children: <Widget>[
                      new Card(
                        child: new Column(
                          children: <Widget>[
                            new Padding(padding: new EdgeInsets.all(15.0)),
                            new Text('From: ' + document['name'],
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0)),
                            new Padding(padding: new EdgeInsets.all(15.0)),
                            new Text(
                              document['text'],
                              style: TextStyle(
                                fontSize: 17.0,
                              ),
                            ),
                            new Padding(
                                padding: new EdgeInsets.all(15.0),
                                child: new Row(
                                  children: <Widget>[
                                    new Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          80.0, 0.0, 0.0, 0.0),
                                      child: Text(
                                        'Comment date: ' + document['date'].toString(),
                                        style: new TextStyle(
                                            fontSize: 12.0, color: Colors.blue),
                                      ),
                                    )
                                  ],
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            );
        });
  }

  _Comments(DocumentSnapshot s) {
    postId = s;
  }

  @override
  Widget build(BuildContext context) {
    Widget allcards;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Comments',
        ),
      ),

      body: getAllPosts(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NewCommentPage(postId)));
        },
      ),
    );
  }
}

class MyPost extends StatefulWidget {
  @override
  _MyPost createState() => new _MyPost();
}

class _MyPost extends State<MyPost> {
  Stream<QuerySnapshot> postStream () {
    var uid;

     FirebaseAuth.instance
        .currentUser()
        .then((FirebaseUser user) {
      uid = user.uid;
    });
    return Firestore.instance.collection('Posts').where("uid", isEqualTo: uid).snapshots();

  }
  @override
  Widget build(BuildContext context) {

    void _showToast(BuildContext context, String message) {
      final scaffold = Scaffold.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: Text(message),
          action: SnackBarAction(
              label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
        ),
      );
    }
    Widget getAllPosts() {
      return new StreamBuilder<QuerySnapshot>(
          stream: postStream(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return new Text('Loading...');
            else
              return new ListView(
                children:
                snapshot.data.documents.map((DocumentSnapshot document) {
                  return new Container(
                    child: new Column(
                      children: <Widget>[
                        new Card(
                          child: new Column(
                            children: <Widget>[
                              new Padding(padding: new EdgeInsets.all(15.0)),
                              new Text('Title: ' + document['title'],
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0)),
                              new Padding(padding: new EdgeInsets.all(15.0)),
                              new Text(
                                document['text'],
                                style: TextStyle(
                                  fontSize: 17.0,
                                ),
                              ),
                              new Padding(
                                  padding: new EdgeInsets.all(15.0),
                                  child: new Row(
                                    children: <Widget>[
                                      new Padding(
                                        padding: new EdgeInsets.all(1.0),
                                        child: new IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () async{
                                            await Firestore.instance.collection("Posts").document(document.documentID).delete();
                                            _showToast(context, "Post is deleted successfully!");
                                            Navigator.pop(context,
                                                MaterialPageRoute(builder: (context) => PostPage()));
                                          },
                                        ),
                                      ),
                                      new Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            80.0, 0.0, 0.0, 0.0),
                                        child: Text(
                                          'Post date: ' + document['date'].toString(),
                                          style: new TextStyle(
                                              fontSize: 12.0, color: Colors.blue),
                                        ),
                                      )
                                    ],
                                  ))
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }).toList(),
              );
          });
    }

    Widget allcards;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'My Posts',
        ),
      ),
      body: getAllPosts()
    );
  }
}

class PostPage extends StatefulWidget {
  @override
  _PostPage createState() => new _PostPage();
}

class NewPost extends StatefulWidget {
  @override
  _NewPost createState() => new _NewPost();
}

class _NewPost extends State<NewPost> {
  final myController = TextEditingController();
  final myController2 = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myController.dispose();
    myController2.dispose();
    super.dispose();
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  Widget build(BuildContext context) {
    Widget allcards;
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
            'New Post',
          ),
        ),
        body: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                TextField(
                  controller: myController,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'Title'),
                ),
                new TextField(
                  controller: myController2,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'Post Text'),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
                new RaisedButton(
                  child: const Text('Add'),
                  color: Theme.of(context).accentColor,
                  elevation: 4.0,
                  splashColor: Colors.blueGrey,
                  onPressed: () async {
                    var uid, creator;
                    await FirebaseAuth.instance
                        .currentUser()
                        .then((FirebaseUser user) {
                      uid = user.uid;
                    });
                    await Firestore.instance
                        .collection('Users')
                        .document(uid)
                        .get()
                        .then((data) {
                      creator = data.data['Name'];
                    });
                    Firestore.instance.collection("Posts").add({
                      "title": myController.text,
                      "text": myController2.text,
                      "date": new DateTime.now(),
                      "uid": uid,
                      "creator": creator
                    }).then((a) {
                      _showToast(context, "Post is generated successfully!");
                      Navigator.pop(context,
                          MaterialPageRoute(builder: (context) => NewPost()));
                    });
                  },
                ),
              ],
            )
          ],
        ));
  }
}

class _PostPage extends State<PostPage> {
  Widget getAllPosts() {
    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('Posts').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return new Text('Loading...');
          else
            return new ListView(
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                return new Container(
                  child: new Column(
                    children: <Widget>[
                      new Card(
                        child: new Column(
                          children: <Widget>[
                            new Padding(padding: new EdgeInsets.all(15.0)),
                            new Text('Title: ' + document['title'],
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0)),
                            new Padding(padding: new EdgeInsets.all(15.0)),
                            new Text(
                              document['text'],
                              style: TextStyle(
                                fontSize: 17.0,
                              ),
                            ),
                            new Padding(
                                padding: new EdgeInsets.all(15.0),
                                child: new Row(
                                  children: <Widget>[
                                    new Padding(
                                      padding: new EdgeInsets.all(1.0),
                                      child: new IconButton(
                                        icon: Icon(Icons.comment),
                                        onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (context) => Comments(document)));
                                        },
                                      ),
                                    ),
                                    new Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          80.0, 0.0, 0.0, 0.0),
                                      child: Text(
                                        'Post date: ' + document['date'].toString(),
                                        style: new TextStyle(
                                            fontSize: 12.0, color: Colors.blue),
                                      ),
                                    )
                                  ],
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            );
        });
  }

  @override
  Widget build(BuildContext context) {
    Widget allcards;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Posts',
        ),
      ),
      body: getAllPosts(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NewPost()));
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            RaisedButton(
              child: const Text('My Posts'),
              color: Theme.of(context).accentColor,
              elevation: 4.0,
              splashColor: Colors.blueGrey,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyPost()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
