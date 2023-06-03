import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AllHistory extends StatelessWidget {
  AllHistory({super.key});

  var Textstyle = TextStyle(fontWeight: FontWeight.bold);
  boldText(String msg) {
    Text(msg, style: TextStyle(fontWeight: FontWeight.bold));
  }

  @override
  Widget build(BuildContext context) {
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
          'ALL HISTORY',
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
            Icons.home,
            size: 25,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('History').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final mydata = snapshot.data!.docs;
              return ListView.builder(
                itemCount: mydata.length,
                itemBuilder: (context, i) {
                  return Card(
                    child: ListTile(
                        leading: mydata[i]['type'] == 'Credit'
                            ? Wrap(
                                direction: Axis.horizontal,
                                children: [
                                  Text(
                                    '\₦${mydata[i]['Ammount'].toStringAsFixed(2)}',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    ' Credited',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  Text(
                                    ' to ${mydata[i]['Name']}',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ],
                              )
                            : mydata[i]['type'] == 'Debit'
                                ? Wrap(
                                    direction: Axis.horizontal,
                                    children: [
                                      Text(
                                        '\₦${mydata[i]['Ammount'].toStringAsFixed(2)}',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      Text(
                                        ' Debited',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      Text(
                                        ' to ${mydata[i]['Name']}',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  )
                                : mydata[i]['type'] == 'deposit'
                                    ? Wrap(
                                        direction: Axis.horizontal,
                                        children: [
                                          Text(
                                            '\₦${mydata[i]['Ammount'].toStringAsFixed(2)}',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          Text(
                                            ' Deposited alert',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                          Text(
                                            ' by ${mydata[i]['Name']}',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      )
                                    : mydata[i]['type'] == 'added'
                                        ? Wrap(
                                            direction: Axis.horizontal,
                                            children: [
                                              Text(
                                                'Member',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              Text(
                                                ' Added:',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                              Text(
                                                ' ${mydata[i]['Name']}',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ],
                                          )
                                        : Wrap(
                                            direction: Axis.horizontal,
                                            children: [
                                              Text(
                                                'Member',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              Text(
                                                ' Deleted:',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                ' ${mydata[i]['Name']}',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ],
                                          ),
                        // leading: Text(
                        //   mydata[i]['type'] == 'Credit'
                        //       ? '\$${mydata[i]['Ammount']} Credited to ${mydata[i]['Name']}'
                        //       : mydata[i]['type'] == 'Debit'
                        //           ? '\$${mydata[i]['Ammount']} Debited to ${mydata[i]['Name']}'
                        //           : mydata[i]['type'] == 'deposit'
                        //               ? '\$${mydata[i]['Ammount']} Deposit alert by ${mydata[i]['Name']}'
                        //               : mydata[i]['type'] == 'added'
                        //                   ? 'MemberAdded: ${mydata[i]['Name']}'
                        //                   : 'Member deleted: ${mydata[i]['Name']}',
                        //   style: TextStyle(fontSize: 17),
                        // ),
                        trailing: Text(
                          '${DateFormat('dd-MM-yyyy').format(mydata[i]['date'].toDate())}',
                          style: TextStyle(fontSize: 15),
                        )),
                  );
                },
              );
            }
            return Center(
                child: CircularProgressIndicator(color: Color(0xFF83050C)));
          }),
    );
  }
}
