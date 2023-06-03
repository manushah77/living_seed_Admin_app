import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../admin_chat/adminchatroom.dart';
import '../../models/members.dart';

class MessageMemberSearch extends StatefulWidget {
  String? compId;
  String? modelid;
  List? docid = [];
  String? userid;
  String? name;
  MessageMemberSearch({
    required this.compId,
    required this.modelid,
    required this.userid,
    required this.docid,
    required this.name,
  });
  @override
  _MessageMemberSearchState createState() => _MessageMemberSearchState();
}

class _MessageMemberSearchState extends State<MessageMemberSearch> {
  final String name = '';

  bool isLoading = false;
  String? id;
  final TextEditingController _search = TextEditingController();

  Map<String, dynamic>? userMap;
  List<MemberData> data = [];
  List<MemberData> dummy = [];

  Future getMembers() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Members')
        .where('Employee_Off', isEqualTo: widget.compId)
        .get();
    if (snapshot.docs.isNotEmpty) {
      data = snapshot.docs
          .map((e) => MemberData.fromMap(e.data() as Map<String, dynamic>))
          .toList();
      dummy = data;
      isLoading = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    getMembers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screesize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false,
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
        body: isLoading
            ? Center(
                child: Container(
                  height: screesize.height / 25,
                  width: screesize.width / 12,
                  child: const CircularProgressIndicator(
                    color: Colors.orange,
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 19),
                      child: Container(
                        height: screesize.height / 15,
                        width: screesize.width / 1,
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
                          controller: _search,
                          onChanged: (value) {
                            if (value == '') {
                              dummy = data;
                            } else {
                              dummy = data
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
                      height: 30,
                    ),
                    dummy.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: dummy.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  hoverColor: Colors.amber,
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => AdminChatRoom(
                                                  chatRoomId:
                                                      '${widget.modelid}',
                                                  docId: '${widget.docid}',
                                                  userId: widget.userid!,
                                                  name: widget.name!,
                                                )));
                                    print(
                                        '${widget.modelid}${widget.userid}${widget.docid}${widget.name}');
                                  },
                                  title: Text(
                                    '${dummy[index].fname}',
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
                          )
                        : Container(
                            child: Center(child: Text('search  by name')),
                          ),
                  ],
                ),
              ),
      ),
    );
  }
//
}
