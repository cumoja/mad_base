import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:create_social/pages/authentication.dart';

import 'widgets/loading.dart';

Future<void> main() async {
  //Always needed for firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const SocialApp());
}

class SocialApp extends StatelessWidget {
  const SocialApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SocialApp',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Authentication());
  }
}
