import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:living_seed_admin/Admin_screens/welcome_back_screen.dart';

import '../Add_catageory/add_catogory.dart';
import '../Widgets/buttons/small_btn.dart';

class AdminSetting extends StatefulWidget {
  const AdminSetting({Key? key}) : super(key: key);

  @override
  State<AdminSetting> createState() => _AdminSettingState();
}

class _AdminSettingState extends State<AdminSetting> {
  TextEditingController category = TextEditingController();
  TextEditingController bankName = TextEditingController();
  TextEditingController accHolder = TextEditingController();
  TextEditingController accNumber = TextEditingController();
  TextEditingController paymentlinkC = TextEditingController();

  final picker = ImagePicker();
  File? _image;

  Future pickImage() async {
    var pickImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickImage != null) {
        _image = File(pickImage.path);
      } else {}
    });
  }

  Future<String> uploadFile(File _image) async {
    String downloadURL;
    String postId = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("images")
        .child("post_$postId.jpg");
    await ref.putFile(_image);
    downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  uploadToFirebase() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    var screesize = MediaQuery.of(context)
        .size; // screen size of the Phone for responsiveness

    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Color(0xff83050C),
              statusBarIconBrightness:
                  Brightness.light, // For Android (dark icons)
            ),
            elevation: 0,
            centerTitle: true,
            backgroundColor: const Color(0xff83050C),
            title: const Text(
              "ADMIN SETTINGS",
              style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
            ),
            leading: IconButton(
              onPressed: () {
                //Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => WelcomeBack()));
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('Admin').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final mydata = snapshot.data!.docs;

                    return Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: screesize.height / 10.5,
                              width: double.infinity,
                              color: const Color(0xff83050C),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 130.0),
                              child: InkWell(
                                onTap: () async {
                                  var pickImage = await picker.pickImage(
                                      source: ImageSource.gallery);

                                  setState(() {
                                    if (pickImage != null) {
                                      _image = File(pickImage.path);
                                    } else {}
                                  });
                                  String url = await uploadFile(_image!);

                                  FirebaseFirestore.instance
                                      .collection('Admin')
                                      .doc(mydata[0].id)
                                      .update({
                                    "Image": url,
                                  });
                                  // uploadFile(_image!);
                                  // });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.6),
                                          spreadRadius: 2,
                                          blurRadius: 4,
                                          offset: const Offset(0.3, 4)),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.deepOrange,
                                    radius: 50,
                                    child: _image != null
                                        ? Center(
                                            child: ClipOval(
                                              child: Image.file(
                                                _image!,
                                                fit: BoxFit.cover,
                                                height: 300,
                                                width: 300,
                                              ),
                                            ),
                                          )
                                        : profilePhoto(
                                            '${mydata[0]['Image']}',
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 22,
                        ),
                        const Text(
                          'CATEGORIES',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff83050C),
                          ),
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('Categories')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final mydata = snapshot.data!.docs;

                                return Container(
                                    height: screesize.height / 1.75,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      physics: const ScrollPhysics(),
                                      child: Column(
                                        children: [
                                          for (int i = 0;
                                              i < snapshot.data!.docs.length;
                                              i++)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 20.0,
                                                  left: 20,
                                                  top: 10),
                                              child: Container(
                                                height: screesize.height / 14,
                                                width: screesize.width,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.3),
                                                        spreadRadius: 1,
                                                        blurRadius: 2,
                                                        offset: const Offset(
                                                            0.3, 2)),
                                                  ],
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 15.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2.3,
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  '${mydata[i]['Category']}',
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xff83050C),
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700),
                                                                ),
                                                              )
                                                            ],
                                                          )),
                                                      Expanded(
                                                          child: Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  2,
                                                              child: Row(
                                                                children: [
                                                                  // InkWell(
                                                                  //   onTap: () {
                                                                  //     Navigator.of(
                                                                  //             context)
                                                                  //         .push(
                                                                  //             MaterialPageRoute(
                                                                  //       builder: (context) => AddedCatagory(
                                                                  //           catagory:
                                                                  //               mydata[i].get('Category'),
                                                                  //           id: mydata[i].id),
                                                                  //     ));
                                                                  //   },
                                                                  //   child:
                                                                  //     const Text(
                                                                  //   'Rename',
                                                                  //   style: TextStyle(
                                                                  //       color: Color(
                                                                  //           0xff939393),
                                                                  //       fontSize:
                                                                  //           16,
                                                                  //       fontWeight:
                                                                  //           FontWeight.w600),
                                                                  // ),
                                                                  // ),
                                                                  SizedBox(
                                                                    width: 15.w,
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      showDialog(
                                                                          context:
                                                                              context,
                                                                          builder: (_) =>
                                                                              AlertDialog(
                                                                                title: const Text("Are you sure to delete"),
                                                                                content: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                  children: [
                                                                                    MaterialButton(
                                                                                        child: const Text("CANCEL"),
                                                                                        onPressed: () {
                                                                                          Navigator.pop(context);
                                                                                        }),
                                                                                    MaterialButton(
                                                                                        child: const Text("Delete"),
                                                                                        onPressed: () {
                                                                                          FirebaseFirestore.instance.collection('Categories').doc(mydata[i].id).delete();
                                                                                          Navigator.pop(context);
                                                                                        }),
                                                                                  ],
                                                                                ),
                                                                              ));
                                                                    },
                                                                    child:
                                                                        const Text(
                                                                      'Delete',
                                                                      style: TextStyle(
                                                                          color: Color(
                                                                              0xff939393),
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                        ],
                                      ),
                                    ));
                              }
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xff83050C),
                                ),
                              );
                            }),
                        const SizedBox(
                          height: 15,
                        ),
                        SmallBtn(
                            txt: 'ADD CATEGORY',
                            ontap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AddCategory()));
                            },
                            clr: Colors.black),
                        const SizedBox(
                          height: 15,
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 23.0),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     // ignore: prefer_const_literals_to_create_immutables
                        //     children: [
                        //       const Text(
                        //         "DISPLAY ACCOUNT DETAILS (Optional)",
                        //         style: TextStyle(
                        //             color: Color(0xff000000),
                        //             fontSize: 15,
                        //             fontWeight: FontWeight.w400),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 10, left: 23.0),
                        //   child: Row(
                        //     children: [
                        //       Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           const Text(
                        //             'BANK NAME',
                        //             style: TextStyle(
                        //                 color: Color(0xff83050C),
                        //                 fontSize: 12,
                        //                 fontWeight: FontWeight.w400),
                        //           ),
                        //           const SizedBox(
                        //             height: 10,
                        //           ),
                        //           Container(
                        //             height: screesize.height / 18,
                        //             width: screesize.width / 2.2,
                        //             decoration: BoxDecoration(
                        //               border: Border.all(
                        //                 color: const Color(0xffDDDCDC),
                        //                 width: 1,
                        //               ),
                        //               borderRadius: BorderRadius.circular(10),
                        //             ),
                        //             child: TextFormField(
                        //               controller: bankName,
                        //               decoration: InputDecoration(
                        //                 hintText:
                        //                     '${mydata[0].get('Bank name')}',
                        //                 contentPadding:
                        //                     EdgeInsets.fromLTRB(10, 15, 0, 15),
                        //                 hintStyle: TextStyle(
                        //                     color: Color(0xffC4C4C4),
                        //                     fontSize: 15,
                        //                     fontWeight: FontWeight.w400),
                        //                 border: InputBorder.none,
                        //               ),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //       const SizedBox(
                        //         width: 13,
                        //       ),
                        //       Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           const Text(
                        //             'ACCOUNT NUMBER',
                        //             style: TextStyle(
                        //                 color: Color(0xff83050C),
                        //                 fontSize: 12,
                        //                 fontWeight: FontWeight.w400),
                        //           ),
                        //           const SizedBox(
                        //             height: 10,
                        //           ),
                        //           Container(
                        //             height: screesize.height / 18,
                        //             width: screesize.width / 2.6,
                        //             decoration: BoxDecoration(
                        //               border: Border.all(
                        //                 color: const Color(0xffDDDCDC),
                        //                 width: 1,
                        //               ),
                        //               borderRadius: BorderRadius.circular(10),
                        //             ),
                        //             child: TextFormField(
                        //               controller: accNumber,
                        //               decoration: InputDecoration(
                        //                 hintText:
                        //                     '${mydata[0].get('Account Number')}',
                        //                 contentPadding:
                        //                     EdgeInsets.fromLTRB(10, 15, 0, 15),
                        //                 hintStyle: TextStyle(
                        //                     color: Color(0xffC4C4C4),
                        //                     fontSize: 15,
                        //                     fontWeight: FontWeight.w400),
                        //                 border: InputBorder.none,
                        //               ),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 10, left: 23.0),
                        //   child: Row(
                        //     children: [
                        //       Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           const Text(
                        //             'ACCOUNT NAME',
                        //             style: TextStyle(
                        //                 color: Color(0xff83050C),
                        //                 fontSize: 12,
                        //                 fontWeight: FontWeight.w400),
                        //           ),
                        //           const SizedBox(
                        //             height: 10,
                        //           ),
                        //           Container(
                        //             height: screesize.height / 18,
                        //             width: screesize.width / 2.18,
                        //             decoration: BoxDecoration(
                        //               border: Border.all(
                        //                 color: const Color(0xffDDDCDC),
                        //                 width: 1,
                        //               ),
                        //               borderRadius: BorderRadius.circular(10),
                        //             ),
                        //             child: TextFormField(
                        //               controller: accHolder,
                        //               decoration: InputDecoration(
                        //                 hintText:
                        //                     '${mydata[0].get('Account Holder Name')}',
                        //                 contentPadding:
                        //                     EdgeInsets.fromLTRB(10, 15, 0, 15),
                        //                 hintStyle: TextStyle(
                        //                     color: Color(0xffC4C4C4),
                        //                     fontSize: 15,
                        //                     fontWeight: FontWeight.w400),
                        //                 border: InputBorder.none,
                        //               ),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //       const SizedBox(
                        //         width: 13,
                        //       ),
                        //       Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Row(
                        //             children: [
                        //               const Text(
                        //                 'PAYMENT LINK',
                        //                 style: TextStyle(
                        //                     color: Color(0xff83050C),
                        //                     fontSize: 12,
                        //                     fontWeight: FontWeight.w400),
                        //               ),
                        //               const Text(
                        //                 '(Without Https)',
                        //                 style: TextStyle(
                        //                   fontSize: 10,
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //           const SizedBox(
                        //             height: 10,
                        //           ),
                        //           Container(
                        //             height: screesize.height / 18,
                        //             width: screesize.width / 2.6,
                        //             decoration: BoxDecoration(
                        //               border: Border.all(
                        //                 color: const Color(0xffDDDCDC),
                        //                 width: 1,
                        //               ),
                        //               borderRadius: BorderRadius.circular(10),
                        //             ),
                        //             child: TextFormField(
                        //               controller: paymentlinkC,
                        //               decoration: InputDecoration(
                        //                 hintText: '${mydata[0].get('Check')}',
                        //                 contentPadding:
                        //                     EdgeInsets.fromLTRB(10, 15, 0, 15),
                        //                 hintStyle: TextStyle(
                        //                     color: Color(0xffC4C4C4),
                        //                     fontSize: 15,
                        //                     fontWeight: FontWeight.w400),
                        //                 border: InputBorder.none,
                        //               ),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // const SizedBox(
                        //   height: 20,
                        // ),
                        // SmallBtn(
                        //     txt: 'SAVE',
                        //     ontap: () async {
                        //       if (bankName.text.isEmpty ||
                        //           accHolder.text.isEmpty ||
                        //           accNumber.text.isEmpty ||
                        //           paymentlinkC.text.isEmpty) {
                        //         showDialog(
                        //             context: context,
                        //             builder: (_) => AlertDialog(
                        //                   title: Text("Alert"),
                        //                   content:
                        //                       Text('Please Fill all Forms'),
                        //                   actions: [CloseButton()],
                        //                 ));
                        //       } else {
                        //         //  print(FirebaseAuth.instance.currentUser!.uid);
                        //         await FirebaseFirestore.instance
                        //             .collection('Admin')
                        //             .doc(FirebaseAuth.instance.currentUser!.uid)
                        //             .update({
                        //           "Bank name": bankName.text,
                        //           "Account Holder Name": accHolder.text,
                        //           "Account Number": accNumber.text,
                        //           "check": paymentlinkC.text
                        //         }).whenComplete(() => showDialog(
                        //                 context: context,
                        //                 builder: (_) => AlertDialog(
                        //                       title: Text("Alert"),
                        //                       content:
                        //                           Text('UpDate Successfully'),
                        //                       actions: [CloseButton()],
                        //                     )));
                        //         Navigator.of(context).push(MaterialPageRoute(
                        //             builder: (context) => WelcomeBack()));
                        //       }
                        //     },
                        //     clr: const Color(0xff83050C))
                      ],
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ),
        ),
        onWillPop: () async => false);
  }

  Widget profilePhoto(String path) => Center(
        child: Stack(
          children: [
            Container(
              height: 140.0,
              width: 140.0,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(255, 255, 255, 0.2),
                    blurRadius: 5.0,
                    offset: Offset(0.0, 5.0),
                  ),
                  BoxShadow(
                    color: Color.fromRGBO(255, 255, 255, 0.2),
                    blurRadius: 5.0,
                    offset: Offset(5.0, 0.0),
                  ),
                ],
                border: Border.all(
                  color: Colors.white,
                  width: 3.0,
                ),
                image: DecorationImage(
                  image: NetworkImage(path),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      );
}
