import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/admindata.dart';
import '../welcome_back_screen.dart';
import 'checkLogin.dart';

class AdminCheck extends StatefulWidget {
  const AdminCheck({super.key});

  @override
  State<AdminCheck> createState() => _AdminCheckState();
}

class _AdminCheckState extends State<AdminCheck> {
  AdminData? adminData;
  Future check() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Admin').get();
    // final currentuser = await FirebaseAuth.instance.currentUser!.uid;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    if (snapshot.docs.isNotEmpty) {
      adminData =
          AdminData.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);

      if (adminData!.addedBy != user) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => CheckLogin()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => WelcomeBack()));
      }
    }
  }

  @override
  void initState() {
    check();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
