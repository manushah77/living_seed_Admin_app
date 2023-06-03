import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../welcome_back_screen.dart';
import 'login_page.dart';


class CheckLogin extends StatefulWidget {
  const CheckLogin({super.key});

  @override
  State<CheckLogin> createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return WelcomeBack();
            } else if (snapshot.hasError) {
              return LogIn();
            } else {
              return LogIn();
            }
          }),
    ));
  }
}
