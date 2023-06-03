import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:living_seed_admin/Admin_screens/search/search_data.dart';

import '../Widgets/buttons/small_btn.dart';
import '../admin_chat/Admin_chat_HomeScreen.dart';
import '../admin_chat/tab_messege_screen.dart';
import 'Login/checkLogin.dart';
import 'admin_setting_screen.dart';
import 'all_history.dart';
import 'all_member_creen/all_member_screen.dart';
import 'newrecord/All_debitor_member.dart';
import 'newrecord/credit_screen.dart';
import 'newrecord/debit_screen.dart';
import 'newrecord/deposit_alert_screen.dart';

// ignore: must_be_immutable
class WelcomeBack extends StatefulWidget {
  WelcomeBack({Key? key}) : super(key: key);

  @override
  _WelcomeBackState createState() => _WelcomeBackState();
}

FirebaseAuth auth = FirebaseAuth.instance;

class _WelcomeBackState extends State<WelcomeBack> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  double tak = 0;
  num sum = 0;
  int msgcounter = 10;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screesize = MediaQuery.of(context)
        .size; // screen size of the Phone for responsiveness

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Color(0xff83050C),
            statusBarIconBrightness:
                Brightness.light, // For Android (dark icons)
          ),
          backgroundColor: const Color(0xff83050C),
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckLogin(),
                      ),
                          (route) => false);
                },
                icon: Icon(Icons.logout_outlined))
          ],
        ),
        body: ListView(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('Admin').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final mydata = snapshot.data!.docs;
                  return Column(
                    children: [
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Admin')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final mydata = snapshot.data!.docs;
                            return Stack(
                              children: [
                                Container(
                                  height: screesize.height / 5.5,
                                  width: double.infinity,
                                  color: const Color(0xff83050C),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 21.0,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              height: 100,
                                              width: 168,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'Welcome',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: const Color(
                                                              0xffFFFFFF)
                                                          .withOpacity(0.8),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 6,
                                                  ),
                                                  Text(
                                                    '${mydata[0]['Company']}',
                                                    style: const TextStyle(
                                                      fontSize: 21,
                                                      color: Color(0xffFFFFFF),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 25.0, top: 50),
                                              child: Container(
                                                height: 45,
                                                width: 45,
                                                decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.25),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(0.1),
                                                          spreadRadius: 2,
                                                          blurRadius: 2,
                                                          offset: const Offset(
                                                              0.3, 2))
                                                    ],
                                                    shape: BoxShape.circle),
                                                child: IconButton(
                                                  onPressed: () {
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            AdminSetting(),
                                                      ),
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    Icons.settings,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 21.0, right: 21, top: 115),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CloudFirestoreSearch(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: screesize.height / 15,
                                      width: screesize.width / 1,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.black12, width: 1),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              blurRadius: 3,
                                              spreadRadius: 1)
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Icon(Icons.search),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          const Text(
                                            'Member Search',
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.3),
                                                fontSize: 20),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xff83050C),
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 21.0, top: 15, right: 22),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TabMessage(
                                            docId: mydata[0].id,
                                            compId: mydata[0].id)),
                                  );
                                },
                                child: Container(
                                  height: screesize.height / 11,
                                  width: screesize.width / 5,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            spreadRadius: 1,
                                            blurRadius: 4),
                                      ]),
                                  child: Column(
                                    children: const [
                                      SizedBox(
                                        height: 3,
                                      ),
                                      CircleAvatar(
                                        radius: 18,
                                        backgroundColor: Color(0xff83050C),
                                        child: Icon(
                                          FontAwesomeIcons.bank,
                                          color: Colors.white,
                                          size: 19,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        'Messages',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xff83050C),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('Members')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final mydata = snapshot.data!.docs;
                                    {
                                      sum = 0;
                                      for (int j = 0;
                                          j < snapshot.data!.docs.length;
                                          j++) {
                                        tak = double.parse(mydata[j]
                                                ['earning_balance']
                                            .toString());
                                        sum += tak;
                                      }
                                    }
                                    return Container(
                                      height: screesize.height / 10.3,
                                      width: MediaQuery.of(context).size.width /
                                          1.6,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(13),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xff83050C),
                                            Color(0xff83050C),
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            width: 14,
                                          ),
                                          const Text(
                                            'Outstanding',
                                            style: TextStyle(
                                                color: Color(0xffFFFFFF),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          const SizedBox(
                                            width: 38,
                                          ),
                                          Text(
                                            "\₦ ${sum.toStringAsFixed(2)}",
                                            style: const TextStyle(
                                                color: Color(0xffFFFFFF),
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreditScreen()),
                              );
                            },
                            child: Container(
                              height: screesize.height / 5.4,
                              width: screesize.width / 2.4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xffFF7F27),
                                    Color(0xffFFA96D),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.8),
                                    spreadRadius: 2,
                                    blurRadius: 3,
                                    offset: const Offset(0, 3),
                                  )
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Image.asset('images/arc.png'),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 10),
                                    child: Image.asset(
                                      'assets/icons/transport.png',
                                      height: 60,
                                      width: 60,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, top: 68),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'CREDIT',
                                          style: TextStyle(
                                              color: Color(
                                                0xffFFFFFF,
                                              ),
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            FontAwesomeIcons.plus,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(left: 10.0, top: 105),
                                    child: Text(
                                      'Transaction',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DebitScreen()),
                              );
                            },
                            child: Container(
                              height: screesize.height / 5.4,
                              width: screesize.width / 2.4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0XffC465FE),
                                    Color(0xffCE90FF),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.8),
                                    spreadRadius: 2,
                                    blurRadius: 3,
                                    offset: const Offset(0, 3),
                                  )
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Image.asset('images/arc.png'),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 10),
                                    child: Image.asset(
                                      'assets/icons/Tuition.png',
                                      height: 60,
                                      width: 60,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, top: 68),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'DEBIT',
                                          style: TextStyle(
                                              color: Color(
                                                0xffFFFFFF,
                                              ),
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            FontAwesomeIcons.minus,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(left: 10.0, top: 105),
                                    child: Text(
                                      'Transaction',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AllMembers(
                                    compId: mydata[0].id,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: screesize.height / 5.4,
                              width: screesize.width / 2.4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xff01CD88),
                                    Color(0xff33D69F),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.8),
                                    spreadRadius: 2,
                                    blurRadius: 3,
                                    offset: const Offset(0, 3),
                                  )
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Image.asset('images/arc.png'),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: Image.asset(
                                          'images/star.png',
                                          height: 60,
                                          width: 60,
                                        ),
                                      ),
                                      const Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, top: 13),
                                        child: Text(
                                          'MEMBERS',
                                          style: TextStyle(
                                              color: Color(
                                                0xffFFFFFF,
                                              ),
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(left: 10.0, top: 5),
                                        child: Text(
                                          'Management',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DepositAlertScreen(),
                                ),
                              );
                            },
                            child: Container(
                              height: screesize.height / 5.4,
                              width: screesize.width / 2.4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xffDA158B),
                                    Color(0xffFF6DB3),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.8),
                                    spreadRadius: 2,
                                    blurRadius: 3,
                                    offset: const Offset(0, 3),
                                  )
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Image.asset('images/arc.png'),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Image.asset(
                                          'assets/icons/Feeding.png',
                                          height: 60,
                                          width: 60,
                                        ),
                                      ),
                                      Row(
                                        children: const [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 10.0, top: 5),
                                            child: Text(
                                              'DEPOSIT ALERT',
                                              style: TextStyle(
                                                  color: Color(
                                                    0xffFFFFFF,
                                                  ),
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(left: 10.0, top: 5),
                                        child: Text(
                                          'Management',
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //   children: [
                      //     InkWell(
                      //       onTap: () {
                      //         Navigator.of(context).push(MaterialPageRoute(
                      //             builder: (context) => AllHistory()));
                      //       },
                      //       child: Text(
                      //         'ALL HISTORY',
                      //         style: TextStyle(
                      //             fontSize: 20, fontWeight: FontWeight.bold),
                      //       ),
                      //     ),
                      //     Row(
                      //       children: [
                      //         InkWell(
                      //           onTap: () {
                      //             setState(() {
                      //               msgcounter = 0;
                      //             });
                      //             Navigator.of(context).push(MaterialPageRoute(
                      //                 builder: (context) =>
                      //                     AdminChatHomeScreen(compId: uid)));
                      //           },
                      //           child: Text(
                      //             'NEW CHAT',
                      //             style: TextStyle(
                      //                 fontSize: 20,
                      //                 fontWeight: FontWeight.bold),
                      //           ),
                      //         ),
                      //         // CircleAvatar(
                      //         //   radius: 15,
                      //         //   backgroundColor: Colors.red,
                      //         //   child: Text("${msgcounter}"),
                      //         // ),
                      //       ],
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SmallBtn(
                              txt: 'All History',
                              ontap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AllHistory()));
                              },
                              clr: Colors.black),
                          SmallBtn(
                            txt: 'DEBTORS',
                            ontap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Debtor(
                                    CompId: mydata[0].id,
                                  ),
                                ),
                              );
                            },
                            clr: const Color(0xff83050C),
                          ),
                        ],
                      ),
                    ],
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xff83050C),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
