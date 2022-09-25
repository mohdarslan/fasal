import 'package:app/screens/home.dart';
import 'package:app/screens/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class CheckLogin extends StatefulWidget {
  const CheckLogin({Key? key}) : super(key: key);

  @override
  State<CheckLogin> createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {
  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser == null
        ? LoginScreen()
        : HomeScreen();
  }
}
