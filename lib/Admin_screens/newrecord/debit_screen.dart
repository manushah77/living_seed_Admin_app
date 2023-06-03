import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Widgets/buttons/large_btn.dart';
import '../../models/cateogryModel.dart';
import '../../models/members.dart';
import '../welcome_back_screen.dart';
import 'package:http/http.dart' as http;

class DebitScreen extends StatefulWidget {
  @override
  State<DebitScreen> createState() => _DebitScreenState();
}

class _DebitScreenState extends State<DebitScreen> {
  final user = FirebaseAuth.instance.currentUser;

  String catID = '';
  String Date1 = '';
  int? amount;
  String? memToken;
  bool secVisible = true;
  String paymentType = '';
  TextEditingController admintext = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController transtype = TextEditingController();

  TextEditingController ammount = TextEditingController();

  TextEditingController reason = TextEditingController();
  String selectedmemberid = "";
  String selectedCompId = "";
  String transtypee = 'Debit';
  String selectedmembernamee = "";
  String selectedCategory = "";

  String selectedmembername = "";

  bool isdebit = false;
  List<CategoryModel> catmodel = [];
  List<MemberData> dummy = [];
  // final item = ['Single Payment', 'Class Payment'];
  String dropdownValue = 'Single Payment';

  // final itemm = ['TRANSPORT', 'UNIFORM', 'TUTION'];
  //String dropdownValuee = 'TRANSPORT';

  double Currentbalance = 0;
  final _formKey = GlobalKey<FormState>();
  List<MemberData> memData = [];
  Future getmember() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Members').get();
    memData = snapshot.docs
        .map((e) => MemberData.fromMap(e.data() as Map<String, dynamic>))
        .toList();
    dummy = memData;
    QuerySnapshot snapshotcat =
        await FirebaseFirestore.instance.collection('Categories').get();
    catmodel = snapshotcat.docs
        .map((e) => CategoryModel.fromMap(e.data() as Map<String, dynamic>))
        .toList();
    setState(() {});
  }

  @override
  void initState() {
    getmember();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screesize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Padding(
          padding: const EdgeInsets.only(top: 4.5),
          child: AppBar(
            elevation: 0,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Color(0xff83050C),
              statusBarIconBrightness:
                  Brightness.light, // For Android (dark icons)
            ),
            leading: IconButton(
              onPressed: () {
                setState(() {
                  ammount.clear();
                  transtype.clear();
                  selectedmembername = '';
                  admintext.clear();
                  selectedCategory = '';
                });
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => WelcomeBack()));
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            backgroundColor: const Color(0xff83050C),
            title: const Text(
              "DEBIT",
              style: const TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 35,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 23.0, right: 23),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ENTER AMOUNT',
                      style: const TextStyle(
                          color: Color(0xff83050C),
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Container(
                      height: screesize.height / 16,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xffDDDCDC),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        validator: (_) {
                          if (_ == null || _ == '') {
                            return ("Enter Amount");
                          } else
                            return null;
                        },
                        controller: ammount,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            hintStyle: TextStyle(
                                //  color: Color(0xffC4C4C4),
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                            hintText: 'Numbers Only',
                            contentPadding:
                                const EdgeInsets.fromLTRB(22, 15, 0, 15),
                            border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 23.0, right: 23, top: 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PAYMENT TYPE',
                      style: const TextStyle(
                          color: const Color(0xff83050C),
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Container(
                        height: screesize.height / 16,
                        width: screesize.width / 1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: const Color(0xffDDDCDC),
                            width: 1,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(right: 8.0, left: 22),
                            child: DropdownButton<String>(
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: const Color(0xff83050C),
                                size: 20,
                              ),
                              value: dropdownValue,
                              iconSize: 24,
                              elevation: 16,
                              style: const TextStyle(
                                  // color: const Color(0xffC4C4C4),
                                  color: Colors.black,
                                  fontSize: 15),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                  if (dropdownValue == 'Catagory Payment') {
                                    secVisible = false;
                                    paymentType = 'Catagory Payment';
                                  } else {
                                    secVisible = true;
                                    paymentType = 'Single Payment';
                                  }
                                });
                              },
                              items: <String>[
                                'Single Payment',
                                'Catagory Payment'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Visibility(
                  visible: secVisible,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 23.0, right: 23),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'STUDENT NAME',
                              style: TextStyle(
                                  color: Color(0xff83050C),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            InkWell(
                              onTap: () {
                                bottomshet(context);
                              },
                              child: Container(
                                height: screesize.height / 16,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xffDDDCDC),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(22, 12, 0, 10),
                                  child: selectedmembername == ""
                                      ? Row(
                                          children: [
                                            const Text(
                                              "Select Member",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  // color: Color(0xffC4C4C4),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            Text(
                                              selectedmembername,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  // const Color(0xffC4C4C4),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 23.0, right: 23),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SELECT TRANSACTION CATEGORY',
                      style: const TextStyle(
                          color: const Color(0xff83050C),
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    InkWell(
                      onTap: () {
                        Categoryshet(context);
                      },
                      child: Container(
                        //height: screesize.height / 16,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xffDDDCDC),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(22, 12, 0, 10),
                          child: selectedCategory == ""
                              ? Row(
                                  children: [
                                    const Text(
                                      "Select Category",
                                      style: const TextStyle(
                                          //color: const Color(0xffC4C4C4),
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    const SizedBox(
                                      width: 135,
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        selectedCategory,
                                        style: const TextStyle(
                                            //color: Color(0xffC4C4C4),
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 175,
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const SizedBox(
                height: 120,
              ),
              const SizedBox(
                height: 15,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Admin')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final mydata = snapshot.data!.docs;
                      return Center(
                        child: Largebtn(
                            txt: 'PREVIEW',
                            ontap: () {
                              if (_formKey.currentState!.validate()) {
                                {
                                  if (selectedCategory.isNotEmpty) {
                                    //shwign confirmation alert

                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title:
                                            Text('Please Confirm Transaction'),
                                        content: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text('Amount: ${ammount.text}'),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    'Payment Type: ${dropdownValue}'),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    'Student Name: ${selectedmembername}'),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Text('Transaction Category:'),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      '${selectedCategory}'),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          MaterialButton(
                                            color: Color(0xff83050C),
                                            height: screesize.height / 15,
                                            minWidth: 300,
                                            child: Text(
                                              'Confirm',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            ),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(13)),
                                            onPressed: () async {
                                              if (secVisible) {
                                                createUserDatabase();
                                                history();
                                                updatebalance(selectedmemberid)
                                                    .whenComplete(() =>
                                                        sendPushMessage(
                                                            'Information',
                                                            '\₦ ${ammount.text} Debited for ${selectedCategory}',
                                                            memToken!));
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            WelcomeBack()));
                                              } else {
                                                for (var item in memData) {
                                                  if (item.categories!
                                                      .contains(catID)) {
                                                    final newD =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'NewRecord')
                                                            .doc();
                                                    Map<String, dynamic> data =
                                                        {
                                                      "Ammount": 0 -
                                                          double.parse(
                                                              ammount.text),
                                                      "Payment Type":
                                                          'Category Payment',
                                                      "typetrans": transtypee,
                                                      "parentName": item.fname,
                                                      "Parentid": item.added,
                                                      "Transaction Category":
                                                          selectedCategory
                                                              .toString(),
                                                      "date": DateTime.now(),
                                                      'CompId': user!.uid,
                                                    };
                                                    await newD.set(data);
                                                    updatebalanceCategory(
                                                        item.added!);
                                                  }
                                                }
                                              }

                                              // setState(() {
                                              //   ammount.clear();
                                              //   transtype.clear();
                                              //   selectedmembername = '';
                                              //   newrecordC.dropdownValue = '';
                                              //   admintext.clear();
                                              //   selectedCategory = '';
                                              // });
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          WelcomeBack()));
                                            },
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          MaterialButton(
                                            color: Colors.black,
                                            height: screesize.height / 15,
                                            minWidth: 300,
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            ),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(13)),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
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
                            clr: Color(0xff83050C)),
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        color: Color(0xff83050C),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
  //getting allmember

  void bottomshet(context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height / 1.5,
                  width: MediaQuery.of(context).size.width / 1.1,
                  child: Scaffold(
                    appBar: AppBar(
                      systemOverlayStyle: const SystemUiOverlayStyle(
                        statusBarColor: Color(0xff83050C),
                        statusBarIconBrightness:
                            Brightness.light, // For Android (dark icons)
                      ),
                      title: const Text('Search Members'),
                      centerTitle: true,
                      backgroundColor: const Color(0xff83050C),
                      leading: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios),
                      ),
                    ),
                    body: Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0, right: 19),
                          child: Container(
                            height: MediaQuery.of(context).size.height / 15,
                            width: MediaQuery.of(context).size.width / 1,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: Colors.black12, width: 1),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 3,
                                    spreadRadius: 1)
                              ],
                            ),
                            child: TextFormField(
                              autofocus: true,
                              textInputAction: TextInputAction.search,
                              cursorColor: const Color(0xff83050C),
                              //focusNode: FocusNode(),
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(15),
                                  hintText: 'Search Members',
                                  border: InputBorder.none,
                                  suffixIcon: Icon(
                                    Icons.search,
                                    color: const Color(0xff83050C),
                                  )),
                              //controller:searchc,
                              onChanged: (value) {
                                if (value == '') {
                                  dummy = memData;
                                } else {
                                  dummy = memData
                                      .where((element) => element.fname!
                                          .toLowerCase()
                                          .contains(value.toLowerCase()))
                                      .toList();
                                }
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        dummy.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  height: 225,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: dummy.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ListTile(
                                        hoverColor: Colors.amber,
                                        onTap: () {
                                          setState(() {
                                            Currentbalance = double.parse(
                                                dummy[index]
                                                    .earmingBalance
                                                    .toString());
                                            selectedCompId =
                                                dummy[index].employee!;
                                            selectedmemberid =
                                                dummy[index].added!;
                                            selectedmembername =
                                                "${dummy[index].fname!} ${dummy[index].lname!}";
                                            memToken = dummy[index].token;
                                            Navigator.pop(context);
                                          });
                                        },
                                        title: Text(
                                          '${dummy[index].fname} ${dummy[index].lname}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        subtitle: Text(
                                          dummy[index].phone.toString(),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                            : Container(
                                child: Center(child: Text('search  by name')),
                              ),
                      ],
                    ),
                  ),
                );
              }),
            ));
  }
  // showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext bc) {
  //       TextEditingController searchC = TextEditingController();
  //       return Container(
  //         height: MediaQuery.of(context).size.height / 1.1,
  //         child: SingleChildScrollView(
  //           scrollDirection: Axis.vertical,
  //           child: Column(
  //             children: [
  //               const SizedBox(
  //                 height: 15,
  //               ),
  //               const Text(
  //                 'Select Member',
  //                 style: const TextStyle(
  //                     color: const Color(0xff83050C),
  //                     fontSize: 20,
  //                     fontWeight: FontWeight.w700),
  //               ),
  //               const SizedBox(
  //                 height: 20,
  //               ),
  //               TextFormField(
  //                 //  autofocus: true,
  //                 textInputAction: TextInputAction.search,
  //                 cursorColor: const Color(0xff83050C),
  //                 //focusNode: FocusNode(),
  //                 decoration: InputDecoration(
  //                     contentPadding: const EdgeInsets.all(15),
  //                     hintText: 'Search Members',
  //                     border: InputBorder.none,
  //                     suffixIcon: Icon(
  //                       Icons.search,
  //                       color: const Color(0xff83050C),
  //                     )),
  //                 controller: searchC,
  //                 onChanged: (value) {
  //                   if (value == '') {
  //                     setState(() {
  //                       dummy = memData;
  //                     });
  //                   } else {
  //                     setState(() {
  //                       dummy = memData
  //                           .where((element) => element.fname!
  //                               .toLowerCase()
  //                               .contains(value.toLowerCase()))
  //                           .toList();
  //                     });
  //                   }
  //                   //setState(() {});
  //                 },
  //               ),
  //               Column(
  //                 children: [
  //                   ListView.builder(
  //                       itemCount: dummy.isEmpty ? 0 : dummy.length,
  //                       shrinkWrap: true,
  //                       primary: false,
  //                       itemBuilder: (context, index) {
  //                         return SingleChildScrollView(
  //                           child: Column(
  //                             children: [
  //                               InkWell(
  //                                 onTap: () {
  //                                   setState(() {
  //                                     Currentbalance = double.parse(
  //                                         dummy[index]
  //                                             .earmingBalance
  //                                             .toString());
  //                                     selectedCompId = dummy[index].employee!;
  //                                     selectedmemberid = dummy[index].added!;
  //                                     selectedmembername =
  //                                         "${dummy[index].fname!} ${dummy[index].lname!}";
  //                                     Navigator.pop(context);
  //                                   });
  //                                 },
  //                                 child: ListTile(
  //                                   title: Row(
  //                                     children: [
  //                                       Text(
  //                                         "${dummy[index].fname!}",
  //                                         style: const TextStyle(
  //                                             color: Colors.black),
  //                                       ),
  //                                       SizedBox(width: 5),
  //                                       Text(
  //                                         "${dummy[index].lname!}",
  //                                         style: const TextStyle(
  //                                             color: Colors.black),
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 ),
  //                               )
  //                             ],
  //                           ),
  //                         );
  //                       })
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     });

  void Categoryshet(context) {
    if (secVisible) {
      MemberData? memberData;
      List<CategoryModel> listCat = [];
      for (var mem in memData) {
        if (selectedmemberid == mem.added) {
          setState(() {
            memberData = mem;
          });
          for (var item in memberData!.categories!) {
            for (var j in catmodel) {
              if (item == j.id) {
                listCat.add(j);
              }
            }
          }

          showModalBottomSheet(
              context: context,
              builder: (BuildContext bc) {
                return Container(
                  height: 250,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          'Select Category',
                          style: const TextStyle(
                              color: const Color(0xff83050C),
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          children: [
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  ListView.builder(
                                      itemCount:
                                          listCat.isEmpty ? 0 : listCat.length,
                                      shrinkWrap: true,
                                      primary: false,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            selectedCategory =
                                                listCat[index].categoryName!;
                                            setState(() {
                                              catID = listCat[index].id!;
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: ListTile(
                                              title: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  listCat[index].categoryName!,
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                ),
                                              )
                                            ],
                                          )),
                                        );
                                      })
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
        }
      }
    } else {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return Container(
              height: 250,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Select Category',
                      style: const TextStyle(
                          color: const Color(0xff83050C),
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Categories')
                              //.where('id', isEqualTo: selectedmemberid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            final sc = snapshot.data;
                            if (snapshot.hasData) {
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    for (int i = 0;
                                        i < snapshot.data!.docs.length;
                                        i++)
                                      InkWell(
                                        onTap: () {
                                          selectedCategory =
                                              sc.docs[i].get("Category");
                                          setState(() {
                                            catID = sc.docs[i].get("id");
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: ListTile(
                                            title: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "${sc!.docs[i].get("Category")}",
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            )
                                          ],
                                        )),
                                      )
                                  ],
                                ),
                              );
                            }
                            return const CircularProgressIndicator();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
    }
  }

  //saving new record
  Future createUserDatabase() async {
    Map<String, dynamic> data = {
      "Ammount": 0 - double.parse(ammount.text),
      "Payment Type": dropdownValue,
      "typetrans": transtypee,
      "parentName": selectedmembername.toString(),
      "Parentid": selectedmemberid.toString(),
      "Transaction Category": selectedCategory.toString(),
      "date": DateTime.now(),
      'CompId': selectedCompId,
    };
    await FirebaseFirestore.instance.collection("NewRecord").doc().set(data);
  }

  Future history() async {
    Map<String, dynamic> data = {
      "Ammount": double.parse(ammount.text),
      "Payment Type": dropdownValue,
      "type": transtypee,
      "Name": selectedmembername.toString(),
      "memberId": selectedmemberid.toString(),
      "Transaction Category": selectedCategory.toString(),
      "date": DateTime.now(),
    };
    await FirebaseFirestore.instance.collection("History").doc().set(data);
  }
  //updating balance

  Future updatebalance(String memID) async {
    if (transtypee == "Credit") {
      try {
        FirebaseFirestore.instance.collection('Members').doc(memID).update({
          "earning_balance": Currentbalance + double.parse(ammount.text.trim()),
        });
      } on FirebaseException catch (e) {
        // print(e);
      }
    } else if (transtypee == "Debit") {
      try {
        FirebaseFirestore.instance.collection('Members').doc(memID).update({
          "earning_balance": Currentbalance - double.parse(ammount.text.trim()),
        });
      } on FirebaseException catch (e) {
        //print(e);
      }
    }
  }

  //updating balance in category payments
  Future updatebalanceCategory(String memID) async {
    await FirebaseFirestore.instance.collection('Members').doc(memID).update({
      "earning_balance":
          FieldValue.increment(0 - double.parse(ammount.text.trim())),
    });
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
      print("error push notification");
    }
  }
}
