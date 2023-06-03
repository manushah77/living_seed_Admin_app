import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../models/deposit_model.dart';
import '../../models/members.dart';
import 'credit_screen2.dart';

class DepositAlertScreen extends StatefulWidget {
  // DepositAlertScreen({this.dep});

  // final String compId;
  // double? dep;

  @override
  State<DepositAlertScreen> createState() => _DepositAlertScreenState();
}

class _DepositAlertScreenState extends State<DepositAlertScreen> {
  double v = 0.0;
  double sum = 0.0;
  int id = 0;

  bool value = false;

  bool descending = false;
  bool viewVisible = true;

  final List<dynamic> values = [];
  List<MemberData> data = [];
  MemberData? memdata;
  final _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    getMembers();
    Future.delayed(Duration.zero, () => _formKey);
  }

  // backgroundColor: const Color(0xff83050C),

  @override
  Widget build(BuildContext context) {
    var screesize = MediaQuery.of(context)
        .size; // screen size of the Phone for responsiveness

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff83050C),
        title: const Center(
          child: Text(
            'NEW DEPOSIT ALERT',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xffFFFFFF),
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.home,
            color: Color(0xffFFFFFF),
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Deposit Add')
                  .where('status', isEqualTo: 'pending')
                  .orderBy('Date', descending: descending)
                  .snapshots(),
              builder: (context, snapshot) {
                List<String> images = [];

                if (snapshot.hasData) {
                  final mydata = snapshot.data!.docs;
                  for (int i = 0; i < snapshot.data!.docs.length; i++) {
                    sum = 0;
                    Deposit deposit = Deposit(checked: false);
                    DepositModel.deposit.add(deposit);

                    for (int j = 0; j < snapshot.data!.docs.length; j++) {
                      // tak = mydata[j]['Deposit Amount'];
                      // sum += tak;
                      // // print(sum);
                      String tak = mydata[j]['Deposit Amount'].toString();
                      v = double.parse(tak);
                      // tak = mydata[j]['Deposit Amount'].toDouble;
                      //  print(v);
                      sum += v;
                      // print(sum);
                    }
                    mydata.forEach((element) {
                      for (var e in data) {
                        if (e.added == element['Added']) {
                          // print(e.imageUrl);
                          images.add(e.imageUrl!);
                        }
                        //print(e.added);
                      }
                      // print(element['Added']);
                    });
                  }
                  for (int i = 0; i < snapshot.data!.docs.length; i++)
                    return Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: screesize.height / 5.9,
                          color: const Color(0xff83050C),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 22.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Total",
                                  style: TextStyle(
                                      color:
                                      Color(0xFFFFFFFF).withOpacity(0.74),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20),
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "\₦ ${sum.toStringAsFixed(2)}",
                                      style: TextStyle(
                                          color: Color(0xFFFFFFFF),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 30.0, bottom: 6),
                                      child: Image.asset(
                                        'images/tick.png',
                                        height: 60,
                                        width: 60,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 17.0, right: 17),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              Text(
                                "Pending Approval",
                                style: TextStyle(
                                    color: Color(0xFF333D41),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        descending = true;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.keyboard_arrow_up,
                                      color: Color(0xff83050C),
                                    ),
                                  ),
                                  Text(
                                    "Sort",
                                    style: TextStyle(
                                        color: Color(0xff83050C),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        descending = false;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Color(0xff83050C),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: screesize.height / 1.83,
                          child: ListView(
                            children: [
                              for (int i = 0;
                              i < snapshot.data!.docs.length;
                              i++)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20, top: 10),
                                  child: Container(
                                    height: screesize.height / 12,
                                    decoration: BoxDecoration(
                                      color: Color(0xffFFFFFF),
                                      borderRadius: BorderRadius.circular(13),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        showDialog(
                                          //showing pop up alert
                                            context: context,
                                            builder: (_) => AlertDialog(
                                              title: Container(
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    children: [
                                                      SizedBox(
                                                        width: 40,
                                                      ),
                                                      Text(
                                                        'Payment Details',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF2F2F2F),
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            fontSize: 18),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      IconButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        icon: Icon(
                                                          Icons.cancel,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              content: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(20)),
                                                height: 250,
                                                width: 360,
                                                child: Column(children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Member:',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF333D41),
                                                            fontWeight:
                                                            FontWeight
                                                                .w300,
                                                            fontSize: 14),
                                                      ),
                                                      Text(
                                                        mydata[i].get(
                                                            'ParentName'),
                                                        style: TextStyle(
                                                            color: Color
                                                                .fromRGBO(
                                                                142,
                                                                55,
                                                                42,
                                                                1),
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            fontSize: 18),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Category:',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF333D41),
                                                            fontWeight:
                                                            FontWeight
                                                                .w300,
                                                            fontSize: 14),
                                                      ),
                                                      Text(
                                                        '${mydata[i].get('Payment Category')}',
                                                        style: TextStyle(
                                                            color: Color
                                                                .fromRGBO(
                                                                142,
                                                                55,
                                                                42,
                                                                1),
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            fontSize: 18),
                                                      ),
                                                    ],
                                                  ),
                                                  // Row(
                                                  //   mainAxisAlignment:
                                                  //       MainAxisAlignment
                                                  //           .spaceBetween,
                                                  //   // ignore: prefer_const_literals_to_create_immutables
                                                  //   children: [
                                                  //     Expanded(
                                                  //       child: Text(
                                                  //         'Category:',
                                                  //         style: TextStyle(
                                                  //             color: Color(
                                                  //                 0xFF333D41),
                                                  //             fontWeight:
                                                  //                 FontWeight
                                                  //                     .w300,
                                                  //             fontSize: 14),
                                                  //       ),
                                                  //     ),
                                                  //     SizedBox(
                                                  //         width: MediaQuery.of(
                                                  //                     context)
                                                  //                 .size
                                                  //                 .width /
                                                  //             2,
                                                  //         child: Row(
                                                  //           mainAxisAlignment:
                                                  //               MainAxisAlignment
                                                  //                   .end,
                                                  //           children: [
                                                  //             Expanded(
                                                  //               child: Text(
                                                  //                 '${mydata[i].get('Payment Category')}',
                                                  //                 style: TextStyle(
                                                  //                     color: Color(
                                                  //                         0xFF333D41),
                                                  //                     fontWeight: FontWeight
                                                  //                         .w300,
                                                  //                     fontSize:
                                                  //                         14),
                                                  //               ),
                                                  //             )
                                                  //           ],
                                                  //         ))
                                                  //   ],
                                                  // ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    // ignore: prefer_const_literals_to_create_immutables
                                                    children: [
                                                      Text(
                                                        'Ammount Paid:',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF333D41),
                                                            fontWeight:
                                                            FontWeight
                                                                .w300,
                                                            fontSize: 14),
                                                      ),
                                                      Text(
                                                        '\₦ ${mydata[i].get('Deposit Amount').toStringAsFixed(2)}',
                                                        style: TextStyle(
                                                            color: Color
                                                                .fromRGBO(
                                                                142,
                                                                55,
                                                                42,
                                                                1),
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            fontSize: 18),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    // ignore: prefer_const_literals_to_create_immutables
                                                    children: [
                                                      Text(
                                                        'Payment Date:',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF333D41),
                                                            fontWeight:
                                                            FontWeight
                                                                .w300,
                                                            fontSize: 14),
                                                      ),
                                                      Text(
                                                        DateFormat(
                                                            'MMM dd yyyy hh:mm a')
                                                            .format((mydata[
                                                        i]
                                                            .get(
                                                            'Date'))
                                                            .toDate()), //'${}',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF333D41),
                                                            fontWeight:
                                                            FontWeight
                                                                .w300,
                                                            fontSize: 14),
                                                      ),
                                                    ],
                                                  ),

                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                          context: context,
                                                          builder:
                                                              (context) =>
                                                              AlertDialog(
                                                                title:
                                                                Row(
                                                                  children: [
                                                                    SizedBox(width: 40),
                                                                    Text('Payment Proof'),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    IconButton(
                                                                      onPressed: () {
                                                                        Navigator.pop(context);
                                                                      },
                                                                      icon: Icon(
                                                                        Icons.cancel,
                                                                        color: Colors.red,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                content:
                                                                Container(
                                                                  height:
                                                                  400,
                                                                  child: mydata[i].get('imgUrl') != null
                                                                      ? Image.network(mydata[i].get('imgUrl'))
                                                                      : Center(child: Text('There is no image')),
                                                                ),
                                                              ));
                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      width:
                                                      double.infinity,
                                                      color:
                                                      Color(0xff83050C),
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            top: 10,
                                                            left: 40),
                                                        child: Text(
                                                          'VIEW TRANSACTION IMAGE',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontSize: 15),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  // Row(
                                                  //   mainAxisAlignment:
                                                  //       MainAxisAlignment.spaceBetween,
                                                  //   // ignore: prefer_const_literals_to_create_immutables
                                                  //   children: [
                                                  //     Text(
                                                  //       'Note:',
                                                  //       style: TextStyle(
                                                  //           color: Color(0xFF333D41),
                                                  //           fontWeight: FontWeight.w300,
                                                  //           fontSize: 14),
                                                  //     ),
                                                  //     Text(
                                                  //       '${mydata[i].get('Note')}',
                                                  //       style: TextStyle(
                                                  //           color: Color(0xFF333D41),
                                                  //           fontWeight: FontWeight.w300,
                                                  //           fontSize: 14),
                                                  //     ),
                                                  //   ],
                                                  // ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                    children: [
                                                      MaterialButton(
                                                        onPressed:
                                                            () async {
                                                          QuerySnapshot snap = await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                              'Members')
                                                              .where(
                                                              'Added',
                                                              isEqualTo:
                                                              mydata[i]
                                                                  .get('Added'))
                                                              .get();
                                                          MemberData
                                                          memData =
                                                          MemberData.fromMap(snap
                                                              .docs
                                                              .first
                                                              .data()
                                                          as Map<
                                                              String,
                                                              dynamic>);
                                                          final deposit =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                              'Deposit Add')
                                                              .doc(snapshot
                                                              .data!
                                                              .docs[
                                                          i]
                                                              .id);
                                                          await deposit
                                                              .delete()
                                                              .whenComplete(() => sendPushMessage(
                                                              'Information',
                                                              '₦ ${mydata[i].get('Deposit Amount')} for ${mydata[i].get('Payment Category')} has been rejected',
                                                              memData
                                                                  .token!));
                                                          Navigator.pop(
                                                              context);
                                                          showDialog(
                                                            context:
                                                            context,
                                                            builder: (_) =>
                                                                AlertDialog(
                                                                  title: Text(
                                                                      'Rejected'),
                                                                  actions: [
                                                                    CloseButton()
                                                                  ],
                                                                ),
                                                          );

                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        color: Color(
                                                            0xff2F2F2F),
                                                        height: 50,
                                                        minWidth: 110,
                                                        child: Text(
                                                          'REJECT',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w600,
                                                              color: Colors
                                                                  .white),
                                                        ),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                10)),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      MaterialButton(
                                                        onPressed:
                                                            () async {
                                                          double paynow =
                                                          mydata[i].get(
                                                              'Deposit Amount');
                                                          String name =
                                                          mydata[i].get(
                                                              'ParentName');
                                                          QuerySnapshot snap = await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                              'Members')
                                                              .where(
                                                              'Added',
                                                              isEqualTo:
                                                              mydata[i]
                                                                  .get('Added'))
                                                              .get();
                                                          MemberData
                                                          memData =
                                                          MemberData.fromMap(snap
                                                              .docs
                                                              .first
                                                              .data()
                                                          as Map<
                                                              String,
                                                              dynamic>);
                                                          // sendPushMessage(
                                                          //     'Information',
                                                          //     'Your deposit \₦ ${mydata[i].get('Deposit Amount')} for ${mydata[i].get('Payment Category')} payment has been approved',
                                                          //     memData
                                                          //         .token!);
                                                          String token =
                                                          memData
                                                              .token!;
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      CreditScreen2(
                                                                        //movig to next screen
                                                                        paynowdone:
                                                                        paynow,
                                                                        paynowname:
                                                                        name,
                                                                        category:
                                                                        '${mydata[i].get('Payment Category')}',
                                                                        memID:
                                                                        '${mydata[i].get('Added')}',

                                                                        memToken:
                                                                        token,
                                                                      )));
                                                          print(token);
                                                          final deposit =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                              'Deposit Add')
                                                              .doc(snapshot
                                                              .data!
                                                              .docs[
                                                          i]
                                                              .id);
                                                          await deposit
                                                              .update({
                                                            'status':
                                                            'approved'
                                                          });
                                                        },
                                                        color: Color(
                                                            0xff83050C),
                                                        height: 50,
                                                        minWidth: 110,
                                                        child: Text(
                                                          'APPROVE',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w600,
                                                              color: Colors
                                                                  .white),
                                                        ),
                                                        shape:
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              10),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ]),
                                              ),
                                            ));
                                      },
                                      child: ListTile(
                                        leading: Container(
                                          height: 40,
                                          width: 40,
                                          child: images[i].isEmpty
                                              ? CircleAvatar(
                                            radius: 17,
                                            backgroundImage: AssetImage(
                                                'assets/images/logo.png'),
                                          )
                                              : CircleAvatar(
                                            radius: 17,
                                            backgroundImage:
                                            NetworkImage(images[i]),
                                          ),
                                        ),
                                        title: Text(
                                          mydata[i].get('ParentName'),
                                          style: TextStyle(
                                              color: Color(0xFF2F2F2F),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16),
                                        ),
                                        subtitle: Text(
                                          'Category: ${mydata[i].get('Payment Category')}',
                                          style: TextStyle(
                                              color: Color(0xFF959595),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 11),
                                        ),
                                        trailing: FittedBox(
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                '\₦${mydata[i]['Deposit Amount'].toStringAsFixed(2)}',
                                                style: TextStyle(
                                                    color: Color(0xFF17BF5F),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MaterialButton(
                              onPressed: () async {
                                for (int i = 0; i < mydata.length; i++) {
                                  final deposit = FirebaseFirestore.instance
                                      .collection('Deposit Add')
                                      .doc(mydata[i].id);
                                  await deposit.update({'status': 'approved'});

                                  QuerySnapshot snap = await FirebaseFirestore
                                      .instance
                                      .collection('Members')
                                      .where('Added',
                                      isEqualTo: mydata[i].get('Added'))
                                      .get();
                                  if (snap.docs.isNotEmpty) {
                                    memdata = MemberData.fromMap(snap.docs.first
                                        .data() as Map<String, dynamic>);
                                    double earningBalance =
                                    memdata!.earmingBalance!;
                                    double Newbalance = earningBalance < 0
                                        ? earningBalance +
                                        mydata[i].get('Deposit Amount')
                                        : earningBalance -
                                        mydata[i].get('Deposit Amount');
                                    final balanceUpdate = FirebaseFirestore
                                        .instance
                                        .collection('Members')
                                        .doc(memdata!.added);
                                    await balanceUpdate.update({
                                      'earning_balance': Newbalance
                                    }).whenComplete(() => sendPushMessage(
                                        'Information',
                                        '₦ ${mydata[i].get('Deposit Amount')} Approved for ${mydata[i].get('Payment Category')}',
                                        memdata!.token!));
                                  }
                                }
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: Text('Approved'),
                                  ),
                                );
                                Navigator.pop(context);
                              },
                              color: Color(0xff83050C),
                              height: screesize.height / 17,
                              minWidth: screesize.width / 2.52,
                              child: Text(
                                'APPROVE All',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ],
                        ),
                      ],
                    );
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'You Have Nothing',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xff83050C),
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }

  CheckboxListTile chekbox() {
    return CheckboxListTile(
      activeColor: Color(0xff83050C),
      checkColor: Colors.white,
      value: value,
      onChanged: (newValue) {
        setState(() {
          id++;
          value = newValue!;
        });
      },
      controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
    );
  }

  Future getMembers() async {
    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('Members').get();
    if (snapshot.docs.isNotEmpty) {
      setState(() {
        data = snapshot.docs
            .map((e) => MemberData.fromMap(e.data() as Map<String, dynamic>))
            .toList();
      });
    }
  }

  sendPushMessage(String title, String body, String token) async {
    try {
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
          'key=AAAA4ZWefKs:APA91bE7oTibqcqMmdvph5Ca6Hd-pmaCTGxltcLdx1NYHhASgPOvUup7b3AYwu3ufyVipfBPo-NzAgiaKxJiljFAfkxuWR3WtncUsOUkLIsNqWLSVHpaDM3_Plu1VArMEV7x5309sWSv',
        },
        body: jsonEncode(
          {
            'notification': {'body': body, 'title': title, "sound": "default"},
            'priority': 'high',
            'data': {
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      // print("error push notification");
    }
  }
}
