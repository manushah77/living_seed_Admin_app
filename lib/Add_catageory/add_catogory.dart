import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Widgets/buttons/large_btn.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  TextEditingController catagoryC = TextEditingController();
  TextEditingController accnameC = TextEditingController();
  TextEditingController accnumberC = TextEditingController();
  TextEditingController banknameC = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Add Catagory'),
        centerTitle: true,
        backgroundColor: Color(0xff83050C),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  validator: (_) {
                    if (_ == '' || _ == null) {
                      return ('Enter catagory');
                    } else {
                      return null;
                    }
                  },
                  maxLength: 15,
                  cursorColor: const Color(0xff83050C),
                  cursorHeight: 20,
                  decoration: InputDecoration(
                    hintText: 'Add Catagory',
                    hintStyle: const TextStyle(
                      color: Color(0xffC4C4C4),
                    ),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xff83050C), width: 1.0),
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xff83050C), width: 1.0),
                        borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xff83050C), width: 1.0),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  controller: catagoryC,
                ),
                SizedBox(height: 20),
                Text(
                  'Bank Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10),
                TextFormField(
                  validator: (_) {
                    if (_ == '' || _ == null) {
                      return ('Enter Account Name');
                    } else {
                      return null;
                    }
                  },
                  cursorColor: const Color(0xff83050C),
                  cursorHeight: 20,
                  decoration: InputDecoration(
                    hintText: 'Account Name',
                    hintStyle: const TextStyle(
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xff83050C), width: 1.0),
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xff83050C), width: 1.0),
                        borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xff83050C), width: 1.0),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  controller: accnameC,
                ),
                SizedBox(height: 10),
                TextFormField(
                  validator: (_) {
                    if (_ == '' || _ == null) {
                      return ('Enter Account Number');
                    } else {
                      return null;
                    }
                  },
                  cursorColor: const Color(0xff83050C),
                  cursorHeight: 20,
                  decoration: InputDecoration(
                    hintText: 'Account Number',
                    hintStyle: const TextStyle(
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xff83050C), width: 1.0),
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xff83050C), width: 1.0),
                        borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xff83050C), width: 1.0),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  controller: accnumberC,
                ),
                SizedBox(height: 10),
                TextFormField(
                  validator: (_) {
                    if (_ == '' || _ == null) {
                      return ('Enter Bank Name');
                    } else {
                      return null;
                    }
                  },
                  cursorColor: const Color(0xff83050C),
                  cursorHeight: 20,
                  decoration: InputDecoration(
                    hintText: 'Bank Name',
                    hintStyle: const TextStyle(
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xff83050C), width: 1.0),
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xff83050C), width: 1.0),
                        borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xff83050C), width: 1.0),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  controller: banknameC,
                ),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.only(left: 34),
                  child: Largebtn(
                      txt: 'Add',
                      ontap: () async {
                        final newCat = FirebaseFirestore.instance
                            .collection('Categories')
                            .doc();
                        if (_formkey.currentState!.validate()) {
                          Map<String, dynamic> deta = {
                            "Category": catagoryC.text,
                            "Added By": FirebaseAuth.instance.currentUser!.uid,
                            "id": newCat.id,
                            "Account Holder Name": accnameC.text,
                            "Account Number": accnumberC.text,
                            "Bank name": banknameC.text,
                          };
                          await newCat.set(deta);
                          catagoryC.clear();
                          accnameC.clear();
                          accnumberC.clear();
                          banknameC.clear();
                          Navigator.pop(context);
                        }
                      },
                      clr: Colors.black),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
