import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:living_seed_admin/Widgets/custom_widgets/pop_up_screen.dart';

import '../../models/depositadd.dart';
import '../../models/newRecord.dart';

class AdminCategoryWidget extends StatefulWidget {
  AdminCategoryWidget({required this.data});

  final NewRecordData data;

  @override
  State<AdminCategoryWidget> createState() => _AdminCategoryWidgetState();
}

class _AdminCategoryWidgetState extends State<AdminCategoryWidget> {
  int categeoryLength = 0;
  List<NewRecordData> newRecordData = [];
  List<DepositAddModel> popUpData = [];

  double amount = 0;
  double deposit = 0;

  //getdata
  Future getData() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('NewRecord')
        .where('Parentid', isEqualTo: widget.data.parentID)
        .where('Transaction Category',
            isEqualTo: widget.data.transactionCategory)
        .get();
    if (snap.docs.isNotEmpty) {
      newRecordData = snap.docs
          .map((e) => NewRecordData.fromMap(e.data() as Map<String, dynamic>))
          .toList();
      categeoryLength = newRecordData.length;

      for (var items in newRecordData) {
        amount += double.parse(items.amount.toString());
      }
    }
    QuerySnapshot snap2 = await FirebaseFirestore.instance
        .collection('Deposit Add')
        .where('Added', isEqualTo: widget.data.parentID)
        .where('Payment Category', isEqualTo: widget.data.transactionCategory)
        .where('status', isEqualTo: 'approved')
        .get();
    if (snap2.docs.isNotEmpty) {
      popUpData = snap2.docs
          .map((e) => DepositAddModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();

      for (var items in popUpData) {
        deposit += double.parse(items.ammount.toString());
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 10, right: 20),
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: Color(0xffC4C4C4),
                title: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 60,
                      ),
                      Expanded(
                        child: Text(
                          '${widget.data.transactionCategory}',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                            color: Color(0xFF83050C),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 25,
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
                ),
                content: Builder(
                  builder: (context) {
                    return Container(
                        height: 300,
                        width: 315,
                        child: ListView.builder(
                            itemCount: categeoryLength,
                            shrinkWrap: true,
                            primary: false,
                            itemBuilder: (context, index) {
                              return PopUp(data: newRecordData[index]);
                            }));
                  },
                ),
              ),
            );
          },
          child: Container(
              width: screenSize.width / 2.3,
              height: screenSize.height / 9.9,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF83050C),
                        Color(0xFF83050C).withOpacity(0.5),
                      ]),
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/icons/design.png',
                    ),
                  )),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Text(
                          '${widget.data.transactionCategory}',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        '\₦ ${amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 23,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              )
              // Stack(
              //   children: <Widget>[
              //     // Positioned(
              //     //   child: Image.asset(
              //     //     'assets/icons/design.png',
              //     //   ),
              //     // ),
              //     // Positioned(
              //     //   top: 12,
              //     //   left: 235,
              //     //   child: Image.asset(
              //     //     'images/prepPig.png',
              //     //     //scale: 5,
              //     //     width: 61.77,
              //     //     height: 61.77,
              //     //   ),
              //     // ),
              //     // if (mydata!.docs[i]
              //     //     .get('typetrans') ==
              //     //     'Credit')
              //     Positioned(
              //         top: 12,
              //         left: 18,
              //         child: Row(
              //           children: [

              //           ],
              //         )),
              //     Positioned(
              //       top: 43,
              //       left: 18,
              //       child: Text(
              //         '\₦ ${amount - deposit}',
              //         style: TextStyle(
              //           fontWeight: FontWeight.w500,
              //           fontSize: 23,
              //           color: Colors.white,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              ),
        ));
  }
}
