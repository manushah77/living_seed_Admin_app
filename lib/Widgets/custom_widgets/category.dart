import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/depositadd.dart';
import '../../models/records.dart';


class CategoryWidget extends StatefulWidget {
  CategoryWidget({required this.data});

  RecordsData? data;

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  int categeoryLength = 0;
  List<RecordsData> NewRecordData = [];
  List<DepositAddModel> popUpData = [];

  double amount = 0;
  double deposit = 0;

  //getdata
  Future getData() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('NewRecord')
        .where('Parentid', isEqualTo: widget.data!.parentID)
        .where('Transaction Category', isEqualTo: widget.data!.category)
        .get();
    if (snap.docs.isNotEmpty) {
      NewRecordData = snap.docs
          .map((e) => RecordsData.fromMap(e.data() as Map<String, dynamic>))
          .toList();

      for (var items in NewRecordData) {
        amount += double.parse(items.ammount.toString());
      }
    }
    QuerySnapshot snap2 = await FirebaseFirestore.instance
        .collection('Deposit Add')
        .where('Added', isEqualTo: widget.data!.parentID)
        .where('Payment Category', isEqualTo: widget.data!.category)
        .where('status', isEqualTo: 'approved')
        .get();
    if (snap2.docs.isNotEmpty) {
      popUpData = snap2.docs
          .map((e) => DepositAddModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();
      categeoryLength = popUpData.length;
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
        child: widget.data!.category != null
            ? InkWell(
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
                                '${widget.data!.category}',
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
                                    return Container();
                                    //return PopUp(data: popUpData[index]);
                                  }));
                        },
                      ),
                    ),
                  );
                },
                child: Container(
                    //width: screenSize.width / 2.3,
                    //height: screenSize.height / 8.3,
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
                      child: Column(
                        children: [
                          Expanded(
                            child: Text(
                              '${widget.data!.category}',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '\₦ ${amount - deposit}',
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 23,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
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
              )
            : Container());
  }
}
