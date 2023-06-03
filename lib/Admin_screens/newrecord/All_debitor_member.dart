import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/members.dart';

class Debtor extends StatefulWidget {
  Debtor({required this.CompId});
  String CompId = '';

  @override
  State<Debtor> createState() => _DebtorState();
}

class _DebtorState extends State<Debtor> {
  List<MemberData> memdata = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getDebitors();
  }

  @override
  Widget build(BuildContext context) {
    var screesize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color(0xFF83050C),
          statusBarIconBrightness: Brightness.light, // For Android (dark icons)
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF83050C),
        elevation: 0,
        title: const Text(
          'OWING MEMBERS',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.home_filled,
            size: 25,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          ListView.builder(
              itemCount: memdata.isNotEmpty ? memdata.length : 0,
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 10, right: 20),
                  child: Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width / 1.1,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 20,
                          offset: Offset(0, 12),
                          color: Color.fromRGBO(130, 126, 126, 0.5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Image.asset(
                              'assets/icons/Tfee.png',
                              scale: 5,
                            ),
                            const SizedBox(
                              width: 9,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${memdata[index].fname} ${memdata[index].lname}',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF83050C),
                                  ),
                                ),
                                Text(
                                  'Debitor',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF83050C),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 9,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 14,
                              ),
                              Text(
                                '\₦ ${memdata[index].earmingBalance}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFE83632),
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }

  //getting debitors

  Future getDebitors() async {
    try {
      setState(() {
        isLoading = true;
      });
      QuerySnapshot memsnap = await FirebaseFirestore.instance
          .collection('Members')
          .where('earning_balance', isLessThan: 0)
          .get();
      if (memsnap.docs.isNotEmpty) {
        setState(() {
          memdata = memsnap.docs
              .map((e) => MemberData.fromMap(e.data() as Map<String, dynamic>))
              .toList();
        });
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
