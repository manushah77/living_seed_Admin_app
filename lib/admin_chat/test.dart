import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/chatroom.dart';
import '../models/members.dart';
import 'adminchatroom.dart';

class TestData extends StatefulWidget {
  TestData({required this.compId});

  final String compId;

  @override
  State<TestData> createState() => _TestDataState();
}

class _TestDataState extends State<TestData> with WidgetsBindingObserver {
  Map<String, dynamic>? userMap;
  List<MemberData> dummy = [];
  List<MemberData> memData = [];

  bool isLoading = false;
  bool isCheck = false;
  final TextEditingController _search = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future getdata() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Members')
        .where('Employee_Off', isEqualTo: widget.compId)
        .get();
    setState(() {
      memData = snapshot.docs
          .map((e) => MemberData.fromMap(e.data() as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
          'chat With Members',
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
          icon: Icon(
            Icons.home_filled,
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
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 27.0, right: 18, top: 15),
                  child: Container(
                    height: size.height / 15,
                    width: size.width / 1,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.black12, width: 1),
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
                SizedBox(
                  height: size.height / 30,
                ),

                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Members')
                        .where('Employee_Off', isEqualTo: widget.compId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data!.docs;
                        return Column(
                          children: [

                            for (int i = 0; i < snapshot.data!.docs.length; i++)
                              InkWell(
                                onTap: () async {
                                  QuerySnapshot snapchatroom =
                                      await FirebaseFirestore.instance
                                          .collection('chatroom')
                                          .where('members',
                                              arrayContains: data[i].id)
                                          .get();
                                  if (snapchatroom.docs.isNotEmpty) {
                                    ChatroomModel model = ChatroomModel.fromMap(
                                        snapchatroom.docs.first.data()
                                            as Map<String, dynamic>);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AdminChatRoom(
                                                chatRoomId: model.id!,
                                                docId: data[i]['Employee_Off'],
                                                userId: data[i].id,
                                                name: '${data[i]['fname']}',
                                              )),
                                    );
                                  } else {
                                    final newchatRoom = FirebaseFirestore
                                        .instance
                                        .collection('chatroom')
                                        .doc();
                                    ChatroomModel model = ChatroomModel(
                                        id: newchatRoom.id,
                                        members: [
                                          data[i].id,
                                          data[i]['Employee_Off'],
                                        ]);
                                    newchatRoom.set(model.toMap());

                                    //next page
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AdminChatRoom(
                                                chatRoomId: newchatRoom.id,
                                                docId: data[i]['Employee_Off'],
                                                userId: data[i].id,
                                                name: '${data[i]['fname']}',
                                              )),
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12.0, right: 12, top: 5),
                                  child: Container(
                                    height: 90,
                                    width: 330,
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
                                            child: data[i]['Image'] != ''
                                                ? CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                            data[i]['Image']),
                                                  )
                                                : CircleAvatar(
                                                    backgroundImage: AssetImage(
                                                        'assets/images/logo.jpg'),
                                                  ),
                                          ),
                                        ),
                                        Text(
                                          '${data[i]['fname']}',
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
                                        SizedBox(
                                          width: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      }
                      return Container();
                    }),
              ],
            ),
    );
  }
}
