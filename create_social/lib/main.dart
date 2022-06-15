import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  //Always needed for firebase
  WidgetsFlutterBinding.ensureInitialized();
  runApp(SocialApp());
}

class SocialApp extends StatelessWidget {
  SocialApp({Key? key}) : super(key: key);
  //Usually needed
  final Future<FirebaseApp> _initFirebase = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SocialApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: FutureBuilder(
          initialData: _initFirebase,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Ooops and Error is here."),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loading();
            }
            return const Center(
              child: Text("Good to go."),
            );
          },
        ),
      ),
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
