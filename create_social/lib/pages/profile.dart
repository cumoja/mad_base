import 'package:create_social/pages/authentication.dart';
import 'package:create_social/pages/home.dart';
import 'package:create_social/models/user.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key, required this.observedUser}) : super(key: key);

  final User observedUser;

  @override
  State<Profile> createState() => _State();
}

class _State extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.observedUser.name)),
      body: Center(
        child: Text(widget.observedUser.bio),
      ),
    );
  }
}
