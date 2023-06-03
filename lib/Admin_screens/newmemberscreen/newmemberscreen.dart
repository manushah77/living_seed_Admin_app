import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widgets/buttons/large_btn.dart';
import '../../Widgets/custom_widgets/text_field.dart';
import '../../models/cateogryModel.dart';
import '../../models/chatroom.dart';
import '../all_member_creen/all_member_screen.dart';

// ignore: must_be_immutable
class NewMemberScreen extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  NewMemberScreen({required this.compId});

  String compId;

  @override
  State<NewMemberScreen> createState() => _NewMemberScreenState();
}

class _NewMemberScreenState extends State<NewMemberScreen> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  FirebaseAuth auth = FirebaseAuth.instance;
  List<String> categoryIds = [];
  List<CategoryModel> categorymodels = [];
  // final NewMemberController newMemberController =
  // Get.put(NewMemberController());
  bool loading = false;
  TextEditingController fnameC = TextEditingController();
  TextEditingController lnameC = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController phone = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String emailAdmin = '';
  String passAdmin = '';

  //String dropdownValue = 'SS1';

  //getting categroy list

  Future getCategory() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Categories').get();
    if (snapshot.docs.isNotEmpty) {
      setState(() {
        categorymodels = snapshot.docs
            .map((e) => CategoryModel.fromMap(e.data() as Map<String, dynamic>))
            .toList();
      });
    }
    //getting share preference data
    final storage = await SharedPreferences.getInstance();
    setState(() {
      emailAdmin = storage.getString('email')!;
      passAdmin = storage.getString('password')!;
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  validateInput() {
    var formState = _formKey.currentState;
    if (formState!.validate()) {
      return true;
    } else {
      AutovalidateMode.onUserInteraction;
      return false;
    }
  }

  //registerUser(BuildContext context, String compId) async {}

  Future createUserDatabase(String uid, String compId) async {
    Map<String, dynamic> data = {
      "email": email.text,
      "fname": fnameC.text,
      "lname": lnameC.text,
      "earning_balance": 0,
      "Image": '',
      "Employee_Off": compId,
      'Date': DateTime.now().toString(),
      "Added": _auth.currentUser!.uid,
      'Phone Number': phone.text,
      "status": '',
      'categories': categoryIds,
      'lastseen': DateTime.now(),
      'token': ''
    };
    await FirebaseFirestore.instance
        .collection('Members')
        .doc(_auth.currentUser!.uid)
        .set(data);
  }

  Future history() async {
    Map<String, dynamic> data = {
      "Ammount": '',
      "Payment Type": '',
      "type": 'added',
      "Name": fnameC.text,
      "id": '',
      "Transaction Category": '',
      "date": DateTime.now(),
    };
    await FirebaseFirestore.instance.collection("History").doc().set(data);
  }

  @override
  void initState() {
    getCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screesize = MediaQuery.of(context)
        .size; // screen size of the Phone for responsiveness

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Color(0xff83050C),
          statusBarIconBrightness: Brightness.light, // For Android (dark icons)
        ),
        backgroundColor: const Color(0xff83050C),
        title: Text(
          'NEW MEMBER',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xffFFFFFF),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => AllMembers(compId: widget.compId)));
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xffFFFFFF),
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 46,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 23.0, right: 23),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'FIRST NAME',
                      style: TextStyle(
                          color: Color(0xff83050C),
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    TextFieldWidget(
                      hintText: 'E.g., Benjamin',
                      controller: fnameC,
                      validate: true,
                      errorTxt: 'enter first name',
                      length: 15,
                    ),
                    // TextFormField(
                    //   maxLength: 15,
                    //   validator: (_) {
                    //     if (_ == null || _ == '') {
                    //       return 'Enter First Name';
                    //     } else
                    //       return null;
                    //   },
                    //   // cursorColor: const Color(0xff83050C),
                    //   // cursorHeight: 20,
                    //   decoration: InputDecoration(
                    //     hintText: 'E.g., Benjamin',
                    //     hintStyle: const TextStyle(
                    //       color: Color(0xffC4C4C4),
                    //     ),
                    //     focusedBorder: OutlineInputBorder(
                    //         borderSide: const BorderSide(
                    //             color: Color(0xffC4C4C4), width: 1.0),
                    //         borderRadius: BorderRadius.circular(10)),
                    //     enabledBorder: OutlineInputBorder(
                    //         borderSide: const BorderSide(
                    //             color: Color(0xffC4C4C4), width: 1.0),
                    //         borderRadius: BorderRadius.circular(10)),
                    //   ),
                    //   controller: fnameC,
                    // ),
                  ],
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 23.0, right: 23),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'LAST NAME',
                          style: TextStyle(
                              color: Color(0xff83050C),
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFieldWidget(
                      hintText: 'E.g., Benjamin',
                      controller: lnameC,
                      validate: true,
                      errorTxt: 'enter last name',
                      length: 15,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 23.0, right: 23),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PHONE NUMBER',
                      style: TextStyle(
                          color: Color(0xff83050C),
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    TextFieldWidget(
                      hintText: '+00 0000',
                      controller: phone,
                      validate: true,
                      errorTxt: 'enter phone number',
                      keyboradType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 23.0, right: 23),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: TextStyle(
                          color: Color(0xff83050C),
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    TextFieldWidget(
                      hintText: '123@123.com',
                      controller: email,
                      validate: true,
                      errorTxt: 'enter email',
                      keyboradType: TextInputType.emailAddress,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 23.0, right: 23),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'USER\'S PASSWORD',
                          style: TextStyle(
                              color: Color(0xff83050C),
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                        const Text(
                          '(Admission Number)',
                          style: const TextStyle(
                              color: Color(0xffC4C4C4),
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    TextFieldWidget(
                      hintText: 'password',
                      controller: pass,
                      validate: true,
                      errorTxt: 'enter password',
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12, left: 25),
                    child: Text(
                      'Select Student Catagory(s)',
                      style: const TextStyle(
                          color: Color(0xff83050C),
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
              ListView.builder(
                  itemCount: categorymodels.isEmpty ? 0 : categorymodels.length,
                  shrinkWrap: true,
                  primary: false,
                  itemBuilder: (context, index) {
                    return categoryItem(categorymodels[index], index);
                  }),
              const SizedBox(height: 80),
              Largebtn(
                txt: 'ADD MEMBER',
                clr: Color(0xff83050C),
                ontap: () async {
                  if (_formKey.currentState!.validate()) {
                    if (validateInput()) {
                      if (categoryIds.isNotEmpty) {
                        loading = true;
                        try {
                          UserCredential credential =
                              await _auth.createUserWithEmailAndPassword(
                            email: email.text,
                            password: pass.text,
                          );
                          User? user = credential.user;
                          if (user != null) {
                            await createUserDatabase(user.uid, widget.compId);
                            history();
                            UserCredential _userCredential = await FirebaseAuth
                                .instance
                                .signInWithEmailAndPassword(
                                    email: emailAdmin, password: passAdmin);
                            final newUser =
                                FirebaseAuth.instance.currentUser!.uid;
                            print(newUser);
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text('Member Added'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      fnameC.clear();
                                      lnameC.clear();
                                      email.clear();
                                      phone.clear();
                                      pass.clear();
                                      for (var select in categorymodels) {
                                        setState(() {
                                          select.isSelected = false;
                                        });
                                      }
                                      categoryIds.clear();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AllMembers(
                                                  compId: widget.compId)));
                                    },
                                    child: Text('Ok'),
                                  ),
                                ],
                              ),
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'email-already-in-use') {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Alert'),
                                    content: Text('Email already in use'),
                                    actions: [CloseButton()],
                                  );
                                });
                          } else if (e.code == 'Weak-Password') {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Alert'),
                                    content: Text('weak Password'),
                                    actions: [CloseButton()],
                                  );
                                });
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Alert'),
                                    content: Text(e.code.toString()),
                                    actions: [CloseButton()],
                                  );
                                });
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Color(0xff83050C),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                              content: Text(
                                "${e}",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 19),
                              ),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      } else {
                        return showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Alert'),
                                content: Text('Select Category'),
                                actions: [CloseButton()],
                              );
                            });
                      }
                    }
                  }
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget categoryItem(CategoryModel category, int index) {
    return Container(
        padding: const EdgeInsets.only(
            top: 5.0, bottom: 5.0, left: 30.0, right: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.7,
              child: Row(
                children: [
                  Expanded(
                    child: Text(category.categoryName!),
                  )
                ],
              ),
            ),
            Switch(
                value: category.isSelected ?? false,
                onChanged: (value) {
                  setState(() {
                    category.isSelected = value;
                    if (category.isSelected!) {
                      categoryIds.add(category.id.toString());
                    } else {
                      categoryIds.remove(category.id.toString());
                    }
                  });
                })
          ],
        ));
    // Padding(
    //   padding: const EdgeInsets.only(left: 50.0, right: 50.0, top: 10.0, bottom: 3.0),
    //   child: Container(
    //     height: 30,
    //     padding: const EdgeInsets.all(0.0),
    //     child: SwitchListTile(
    //         title: Text(category.categoryName!),
    //         value: isSelected,
    //         controlAffinity: ListTileControlAffinity.trailing,
    //         onChanged: (value) {
    //           setState(() {
    //             isSelected = value;
    //           });
    //         }),
    //   ),
    // );
  }

  //create chat room

  Future createChatRoom(String adminID, String memeID) async {
    final newChatRoom = FirebaseFirestore.instance.collection('chatroom').doc();
    ChatroomModel newchat =
        ChatroomModel(id: newChatRoom.id, members: [adminID, memeID]);
    await newChatRoom.set(newchat.toMap());
  }
}
