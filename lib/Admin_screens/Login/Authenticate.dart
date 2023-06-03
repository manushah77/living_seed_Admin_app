import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../welcome_back_screen.dart';
import 'checkLogin.dart';


class Authentications extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser != null) {
      return WelcomeBack();
    } else {
      return CheckLogin();
    }
  }
}
