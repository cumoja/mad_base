import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/loading.dart';

class Authentication extends StatefulWidget {
  Authentication({Key? key}) : super(key: key);

  @override
  State<Authentication> createState() => _AuthState();
}

class _AuthState extends State<Authentication> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Authentication Basics"),
        ),
        body: loading
            ? const Loading()
            : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _email,
                      decoration: const InputDecoration(labelText: "Email"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email cannot be empty";
                        }
                        if (!value.contains('@')) {
                          return "Email in wrong format";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _password,
                      decoration: InputDecoration(labelText: "Password"),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password cannot be empty";
                        }
                        if (value.length < 7) {
                          return "Password too short.";
                        }
                        return null;
                      },
                    ),
                    OutlinedButton(onPressed: login, child: Text("LOGIN")),
                    OutlinedButton(
                        onPressed: register, child: Text("REGISTER")),
                    OutlinedButton(
                        onPressed: () {}, child: Text("FORGOT PASSWORD")),
                  ],
                )));
  }

  Future<void> register() async {
    if (_formKey.currentState!.validate()) {
      try {
        var registerResponse = await _auth.createUserWithEmailAndPassword(
            email: _email.text, password: _password.text);
      } catch (e) {}
      setState(() {
        loading = true;
      });
    }
  }

  void login() {
    if (_formKey.currentState!.validate()) {
      _auth
          .signInWithEmailAndPassword(
              email: _email.text, password: _password.text)
          .whenComplete(() => setState(() {
                loading = false;
                _password.clear();
              }));
      setState(() {
        loading = true;
      });
    }
  }
}
