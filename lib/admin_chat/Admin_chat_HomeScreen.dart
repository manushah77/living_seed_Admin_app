import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Admin_screens/welcome_back_screen.dart';
import 'adminchatroom.dart';

class SearchMemberModel {
  final String? chatRoomId;
  final String docId;
  final String userId;
  final bool? isRead;

  final String name;
  final String? image;

  SearchMemberModel({this.chatRoomId,
    this.isRead,
    required this.docId,
    required this.name,
    required this.userId,
    this.image});
}

class AdminChatHomeScreen extends StatefulWidget {
  AdminChatHomeScreen({required this.compId});

  // final String name;
  final String compId;

  // final String docid;
  // final String image;

  @override
  State<AdminChatHomeScreen> createState() => _AdminChatHomeScreenState();
}

class _AdminChatHomeScreenState extends State<AdminChatHomeScreen>
    with WidgetsBindingObserver {
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  bool isCheck = false;

  final TextEditingController _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    getItems();
    Future.delayed(Duration(seconds: 1), () {});
    WidgetsBinding.instance.addObserver(this);
  }

  // Future<dynamic> chatRoomId(String user1, String user2) async {
  //   var res = await FirebaseFirestore.instance
  //       .collection('Members')
  //       .where('chatroom', isEqualTo: '$user1$user2')
  //       .get();
  //
  //   if (res.docs.isEmpty) {
  //     var response = await FirebaseFirestore.instance
  //         .collection('Members')
  //         .where('chatroom', isEqualTo: '$user2$user1')
  //         .get();
  //     if (response.docs.isEmpty) {
  //       return "$user1$user2";
  //     } else {
  //       return res.docs[0].id.toString();
  //     }
  //   } else {
  //     return res.docs[0].id.toString();
  //   }
  // }

  List<SearchMemberModel> allData = [];

  getAllData() async {
    await FirebaseFirestore.instance
        .collection('Members')
        .where('Employee_Off', isEqualTo: widget.compId)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection('chatroom')
            .where('members', arrayContains: element.id)
            .get()
            .then((v) {
          v.docs.forEach((ele) {
            // print(ele['members'][0]);
            if (ele['members'][1] == element['Employee_Off']) {
              FirebaseFirestore.instance
                  .collection('chatroom')
                  .doc(ele.id)
                  .collection('chats')
                  .get()
                  .then((value) {
                value.docs.forEach((doc) {
                  // print(doc['isRead']);
                  // doc.reference.update({'isRead': true});
                });
              });

              setState(() {
                allData.add(SearchMemberModel(
                    chatRoomId: ele.id,
                    docId: element.id,
                    name: element['fname'],
                    image: element['Image'],
                    userId: element['Employee_Off']));
              });
              setState(() {
                items!.addAll(allData);
              });
            }
          });
        });
      });
    });
  }

  List<SearchMemberModel>? items = [];

  filterData(String query) {
    List<SearchMemberModel> dummySearch = [];

    dummySearch.addAll(allData);
    if (query.isNotEmpty) {
      List<SearchMemberModel> dummyData = [];
      dummySearch.forEach((element) {
        if (element.name.toLowerCase().contains(query)) {
          dummyData.add(element);
        }
      });
      setState(() {
        items!.clear();
        items!.addAll(dummyData);
      });
      return;
    } else {
      setState(() {
        items!.clear();
        items!.addAll(allData);
      });
      // return;
    }
  }

  getItems() async {
    await getAllData();
    setState(() {
      items!.addAll(allData);
    });
    // print(' $items');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Color(0xFF83050C),
          statusBarIconBrightness: Brightness.light, // For Android (dark icons)
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF83050C),
        elevation: 0,
        title: Text(
          'Chat With Members',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return WelcomeBack();
            }));
          },
          icon: Icon(
            Icons.home,
            size: 25,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: isLoading
          ? Center(
        child: Text('User Not found,Tap to Search Again'),
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            // Padding(
            //   padding:
            //       const EdgeInsets.only(left: 21.0, right: 21, top: 10),
            //   child: InkWell(
            //     onTap: () {
            //       print("mmmmmmm $myUserid");
            //       // Navigator.pushReplacement(
            //       //   context,
            //       //   MaterialPageRoute(
            //       //     builder: (context) => MessageMemberSearch(
            //       //       compId: widget.compId,
            //       //       modelid: myModelid,
            //       //       userid: myUserid,
            //       //       docid: myDocid,
            //       //       name: myName,
            //       //     ),
            //       //   ),
            //       // );
            //     },
            //     child: Container(
            //       height: size.height / 14,
            //       width: size.width / 1,
            //       decoration: BoxDecoration(
            //         color: Colors.white,
            //         borderRadius: BorderRadius.circular(10),
            //         border: Border.all(color: Colors.black12, width: 1),
            //         boxShadow: [
            //           BoxShadow(
            //               color: Colors.black.withOpacity(0.2),
            //               blurRadius: 3,
            //               spreadRadius: 1)
            //         ],
            //       ),
            //       child: Row(
            //         children: [
            //           const SizedBox(
            //             width: 5,
            //           ),
            //           IconButton(
            //             icon: const Icon(
            //               Icons.search,
            //               color: const Color(0xff83050C),
            //               size: 25,
            //             ),
            //             onPressed: () {
            //               // Navigator.pushReplacement(
            //               //   context,
            //               //   MaterialPageRoute(
            //               //     builder: (context) => MessageMemberSearch(
            //               //       compId: widget.compId,
            //               //       modelid: myModelid,
            //               //       userid: myUserid,
            //               //       docid: myDocid,
            //               //       name: myName,
            //               //     ),
            //               //   ),
            //               // );
            //             },
            //           ),
            //           const SizedBox(
            //             width: 15,
            //           ),
            //           const Text(
            //             'Search member...',
            //             style: TextStyle(
            //                 color: Color.fromRGBO(0, 0, 0, 0.2),
            //                 fontSize: 20),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding:
              const EdgeInsets.only(left: 27.0, right: 18, top: 15),
              child: Container(
                height: size.height / 15,
                width: size.width / 1,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black12, width: 1),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 3,
                        spreadRadius: 1)
                  ],
                ),
                child: TextFormField(
                  autofocus: false,
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
                  controller: _search,
                  onChanged: (value) {
                    filterData(_search.text);
                  },
                ),
              ),
            ),

            SizedBox(
              height: size.height / 55,
            ),
            items!.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Container(
              height: size.height / 1.10,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items!.length,
                itemBuilder: (context, index) {
                  FirebaseFirestore.instance
                      .collection('chatroom')
                      .doc(items![index].chatRoomId)
                      .collection('chats')
                      .get();

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AdminChatRoom(
                                  chatRoomId:
                                  items![index].chatRoomId!,
                                  docId: items![index].docId,
                                  userId: items![index].userId,
                                  name: '${items![index].name}',
                                )),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 22.0, right: 12, top: 5),
                      child: Container(
                        height: 90,
                        width: 350,
                        decoration: BoxDecoration(
                            color: Color(0xff83050C),
                            borderRadius:
                            BorderRadius.circular(12)),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                  )),
                              child: Container(
                                height: 50,
                                width: 50,
                                child: items![index].image != ''
                                    ? CircleAvatar(
                                  backgroundImage:
                                  NetworkImage(
                                      allData[index]
                                          .image!),
                                )
                                    : CircleAvatar(
                                  backgroundImage: AssetImage(
                                      'assets/images/logo.jpg'),
                                ),
                              ),
                            ),
                            Text(
                              '${items![index].name}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: 90,
                            ),
                            Checkbox(
                                side: BorderSide(
                                    color: Colors.white,
                                    width: 1.5),
                                value: isCheck,
                                onChanged: (value) {
                                  setState(() {
                                    isCheck = value!;
                                  });
                                }),
                            // Icon(FontAwesomeIcons.message,
                            //     color: Colors.white),
                            // SizedBox(
                            //   width: 15,
                            // ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            //  Padding(
            //   padding: const EdgeInsets.only(left: 18.0, right: 19),
            //   child: Container(
            //     height: MediaQuery.of(context).size.height / 15,
            //     width: MediaQuery.of(context).size.width / 1,
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.circular(10),
            //       border: Border.all(color: Colors.black12, width: 1),
            //       boxShadow: [
            //         BoxShadow(
            //             color: Colors.black.withOpacity(0.2),
            //             blurRadius: 3,
            //             spreadRadius: 1)
            //       ],
            //     ),
            //     child: TextFormField(
            //       autofocus: true,
            //       textInputAction: TextInputAction.search,
            //       cursorColor: const Color(0xff83050C),
            //       //focusNode: FocusNode(),
            //       decoration: InputDecoration(
            //           contentPadding: const EdgeInsets.all(15),
            //           hintText: 'Search Members',
            //           border: InputBorder.none,
            //           suffixIcon: Icon(
            //             Icons.search,
            //             color: const Color(0xff83050C),
            //           )),
            //       controller: _search,
            //       onChanged: (value) {
            //         // if (value == '') {
            //         //   dummy = data;
            //         // } else {
            //         //   dummy = data
            //         //       .where((element) => element.fname!
            //         //           .toLowerCase()
            //         //           .contains(value.toLowerCase()))
            //         //       .toList();
            //         // }
            //         setState(() {});
            //       },
            //     ),
            //   ),
            // ),

            // StreamBuilder<QuerySnapshot>(
            //     stream: FirebaseFirestore.instance
            //         .collection('Members')
            //         .where('Employee_Off', isEqualTo: widget.compId)
            //         .snapshots(),
            //     builder: (context, snapshot) {
            //       if (snapshot.hasData) {
            //         final data = snapshot.data?.docs;
            //         return
            //         Column(
            //           children: [
            //             for (int i = 0;
            //                 i < snapshot.data!.docs.length;
            //                 i++)
            //               InkWell(
            //                 onTap: () async {
            //                   QuerySnapshot snapchatroom =
            //                       await FirebaseFirestore.instance
            //                           .collection('chatroom')
            //                           .where('members',
            //                               arrayContains: data[i].id)
            //                           // .orderBy('time', descending: false)
            //                           .get();
            //                   if (snapchatroom.docs.isNotEmpty) {
            //                     ChatroomModel model =
            //                         ChatroomModel.fromMap(
            //                             snapchatroom.docs.first.data()
            //                                 as Map<String, dynamic>);
            //                     // myModelid = model.id;
            //                     // myDocid = data[i]['Employee_Off'];
            //                     // myUserid = data[i].id;
            //                     // myName = '${data[i]['fname']}';
            //                     Navigator.push(
            //                       context,
            //                       MaterialPageRoute(
            //                           builder: (context) => AdminChatRoom(
            //                                 chatRoomId: model.id!,
            //                                 docId: data[i]
            //                                     ['Employee_Off'],
            //                                 userId: data[i].id,
            //                                 name: '${data[i]['fname']}',
            //                               )),
            //                     );
            //                   } else {
            //                     final newchatRoom = FirebaseFirestore
            //                         .instance
            //                         .collection('chatroom')
            //                         .doc();
            //                     ChatroomModel model = ChatroomModel(
            //                         id: newchatRoom.id,
            //                         members: [
            //                           data[i].id,
            //                           data[i]['Employee_Off'],
            //                         ]);
            //                     newchatRoom.set(model.toMap());

            //                     //next page
            //                     Navigator.push(
            //                       context,
            //                       MaterialPageRoute(
            //                           builder: (context) => AdminChatRoom(
            //                                 chatRoomId: newchatRoom.id,
            //                                 docId: data[i]
            //                                     ['Employee_Off'],
            //                                 userId: data[i].id,
            //                                 name: '${data[i]['fname']}',
            //                               )),
            //                     );
            //                   }
            //                 },
            //                 child: Padding(
            //                   padding: const EdgeInsets.only(
            //                       left: 22.0, right: 12, top: 5),
            //                   child: Container(
            //                     height: 90,
            //                     width: 350,
            //                     decoration: BoxDecoration(
            //                         color: Color(0xff83050C),
            //                         borderRadius:
            //                             BorderRadius.circular(12)),
            //                     child: Row(
            //                       mainAxisAlignment:
            //                           MainAxisAlignment.spaceBetween,
            //                       children: [
            //                         SizedBox(
            //                           width: 5,
            //                         ),
            //                         Container(
            //                           height: 60,
            //                           width: 60,
            //                           decoration: BoxDecoration(
            //                               color: Colors.transparent,
            //                               shape: BoxShape.circle,
            //                               border: Border.all(
            //                                 color: Colors.white,
            //                               )),
            //                           child: Container(
            //                             height: 50,
            //                             width: 50,
            //                             child: data![i]['Image'] != ''
            //                                 ? CircleAvatar(
            //                                     backgroundImage:
            //                                         NetworkImage(
            //                                             data[i]['Image']),
            //                                   )
            //                                 : CircleAvatar(
            //                                     backgroundImage: AssetImage(
            //                                         'assets/images/logo.png'),
            //                                   ),
            //                           ),
            //                         ),
            //                         Text(
            //                           '${data[i]['fname']}',
            //                           style: TextStyle(
            //                             color: Colors.white,
            //                             fontSize: 15,
            //                             fontWeight: FontWeight.w600,
            //                           ),
            //                         ),
            //                         SizedBox(
            //                           width: 90,
            //                         ),
            //                         Checkbox(
            //                             side: BorderSide(
            //                                 color: Colors.white,
            //                                 width: 1.5),
            //                             value: isCheck,
            //                             onChanged: (value) {
            //                               setState(() {
            //                                 isCheck = value!;
            //                               });
            //                             }),
            //                         // Icon(FontAwesomeIcons.message,
            //                         //     color: Colors.white),
            //                         SizedBox(
            //                           width: 15,
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //           ],
            //         );

            //       }
            //       return Center(
            //         child: CircularProgressIndicator(
            //           color: Color(0xff83050C),
            //         ),
            //       );
            //     }),
          ],
        ),
      ),
    );
  }
}
