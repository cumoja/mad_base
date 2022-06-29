import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:create_social/model/post.dart';
import 'package:create_social/model/user.dart' as m;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> _postStream;
  final List<Post> _posts = [];
  List<m.User> users = [];

  @override
  void initState() {
    super.initState();
    getList();
    getStreamList();

    _postStream = _db.collection("posts").snapshots();
  }

  void getStreamList() {
    _db.collection("users").snapshots().listen((snapshots) {
      for (var element in snapshots.docs) {
        setState(() {
          users.add(m.User.fromJson(element.id, element.data()));
        });
      }
    });
  }

  void getList() {
    _db.collection("users").get().then((result) {
      setState(() {
        for (var element in result.docs) {
          users.add(element.data()["name"]);
        }
      });
    });
  }

  void getList2() async {
    var result = await _db.collection("users").get();
    for (var element in result.docs) {
      users.add(element.data()["name"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_auth.currentUser!.uid),
        ),
        body: StreamBuilder(
          stream: _postStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshots) {
            if (snapshots.hasError) {
              return const Center(child: Text("Something has gone wrong"));
            } else if (snapshots.hasData) {
              var posts = snapshots.data!.docs;
            }
            return const Center(
              child: Text("Just something to be here for now"),
            );
          },
        ));
  }
}
