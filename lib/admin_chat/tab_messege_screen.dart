import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../Admin_screens/welcome_back_screen.dart';
import '../models/chatroom.dart';
import '../models/memModel.dart';
import '../models/members.dart';

class TabMessage extends StatefulWidget {
  final String docId;
  final String compId;

  TabMessage({required this.docId, required this.compId});

  @override
  State<TabMessage> createState() => _TabMessageState();
}

class _TabMessageState extends State<TabMessage> {
  bool isLoading = false;
  List<MemberData> allmembers = [];
  List<MemberData> owingmembers = [];
  List<MemberData> notOwingmembers = [];
  List<SelectedMem> selectedMem = [];
  List<SelectedMem> selected4Message = [];
  bool isvisible = false;
  List<String> sendMessagesIds = [];

  final TextEditingController _message = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String _selectedMember = '';

  @override
  void initState() {
    getMembers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screesize = MediaQuery.of(context)
        .size; // screen size of the Phone for responsiveness

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color(0xff83050C),
          statusBarIconBrightness: Brightness.light, // For Android (dark icons)
        ),
        backgroundColor: const Color(0xff83050C),
        title: const Text(
          'MESSAGES',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Color(0xffFFFFFF),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => WelcomeBack()));
          },
          icon: const Icon(
            Icons.home,
            color: Color(0xffFFFFFF),
          ),
        ),
        elevation: 0,
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: isLoading
            ? SizedBox(
                height: 100,
                width: 100,
                child: Center(
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballPulse,
                    colors: [Colors.red],
                  ),
                ),
              )
            : Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: const Color(0xff83050C),
                    child: Column(
                      children: [],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 23.0, right: 23, top: 15, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'MESSAGE',
                          style: TextStyle(
                              color: Color(0xff83050C),
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: screesize.height / 5.5,
                    width: 320,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xffDDDCDC),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        maxLines: null,
                        maxLength: null,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10),
                          labelText: 'Type Message',
                          border: InputBorder.none,
                        ),
                        controller: _message,
                        validator: (_) {
                          if (_ == null || _ == '') {
                            return 'Write the message';
                          } else
                            return null;
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 35,
                    width: double.infinity,
                    child: ListTile(
                      leading: Radio<String>(
                        activeColor: const Color(0xff83050C),
                        value: 'All Members',
                        groupValue: _selectedMember,
                        onChanged: (value) {
                          setState(() {
                            _selectedMember = value!;
                            isvisible = false;
                          });
                        },
                      ),
                      title: const Text('All Members'),
                    ),
                  ),
                  Container(
                    height: 35,
                    width: double.infinity,
                    child: ListTile(
                      leading: Radio<String>(
                        activeColor: const Color(0xff83050C),
                        value: 'Owing Members',
                        groupValue: _selectedMember,
                        onChanged: (value) {
                          setState(() {
                            _selectedMember = value!;
                            isvisible = false;
                          });
                        },
                      ),
                      title: const Text('Owing Members'),
                    ),
                  ),
                  Container(
                    height: 35,
                    width: double.infinity,
                    child: ListTile(
                      leading: Radio<String>(
                        activeColor: const Color(0xff83050C),
                        value: 'Not Owing Members',
                        groupValue: _selectedMember,
                        onChanged: (value) {
                          setState(() {
                            _selectedMember = value!;
                            isvisible = false;
                          });
                        },
                      ),
                      title: const Text('Not Owing Members'),
                    ),
                  ),
                  // Container(
                  //   height: 35,
                  //   width: double.infinity,
                  //   child: ListTile(
                  //     leading: Radio<String>(
                  //       activeColor: const Color(0xff83050C),
                  //       value: 'Selecte Members',
                  //       groupValue: _selectedMember,
                  //       onChanged: (value) {
                  //         setState(() {
                  //           _selectedMember = value!;
                  //           isvisible = true;
                  //         });
                  //       },
                  //     ),
                  //     title: const Text('Selected Members'),
                  //   ),
                  // ),
                  const SizedBox(
                    height: 30,
                  ),
                  Visibility(
                      visible: isvisible,
                      child: Container(
                        margin: EdgeInsets.only(left: 40, right: 40),
                        padding: EdgeInsets.only(
                            top: 5, bottom: 5, left: 10, right: 10),
                        height: 300,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black, style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(20)),
                        child: ListView.builder(
                            itemCount:
                                allmembers.isEmpty ? 0 : allmembers.length,
                            shrinkWrap: true,
                            primary: false,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  selectedMem[index].name!,
                                  style: TextStyle(
                                      color: Color(0xFF2F2F2F),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16),
                                ),
                                subtitle: Text(
                                  selectedMem[index].earningBalance!,
                                  style: TextStyle(
                                      color: Color(0xFF959595),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 11),
                                ),
                                trailing: FittedBox(
                                  child: Switch(
                                      value: selectedMem[index].isSelected ??
                                          false,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedMem[index].isSelected = value;
                                          if (selectedMem[index].isSelected ==
                                              true) {
                                            selected4Message
                                                .add(selectedMem[index]);
                                          } else {
                                            selected4Message
                                                .remove(selectedMem[index]);
                                          }
                                        });
                                      }),
                                ),
                              );
                            }),
                      )),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 40.0, right: 40, top: 90),
                    child: MaterialButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await sendMessages();
                        }
                      },
                      color: const Color(0xff83050C),
                      height: 40,
                      minWidth: 300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Text(
                        'SEND NOW',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xffFFFFFF),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  //getting all members

  Future getMembers() async {
    setState(() {
      isLoading = true;
    });

    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Members').get();
    if (snapshot.docs.isNotEmpty) {
      allmembers = snapshot.docs
          .map((e) => MemberData.fromMap(e.data() as Map<String, dynamic>))
          .toList();

      //owimng memebers

      owingmembers =
          allmembers.where((element) => element.earmingBalance! < 0).toList();
      //non owing members

      notOwingmembers =
          allmembers.where((element) => element.earmingBalance! > 0).toList();

      //selected member

      selectedMem = allmembers
          .map((e) => SelectedMem(
              earningBalance: e.earmingBalance.toString(),
              id: e.added,
              name: e.fname))
          .toList();
    }
    isLoading = false;
    setState(() {});
  }

  //send messages

  Future sendMessages() async {
    final user = FirebaseAuth.instance.currentUser!;
    setState(() {
      isLoading = true;
      sendMessagesIds.clear();
    });
    //checking chatroom
    if (_selectedMember == 'All Members') {
      if (sendMessagesIds.isEmpty) {
        for (var id in allmembers) {
          setState(() {
            sendMessagesIds.add(id.added!);
          });
        }
      }
    } else if (_selectedMember == 'Owing Members') {
      if (sendMessagesIds.isEmpty) {
        for (var id in owingmembers) {
          setState(() {
            sendMessagesIds.add(id.added!);
          });
        }
      }
    } else if (_selectedMember == 'Not Owing Members') {
      if (sendMessagesIds.isEmpty) {
        for (var id in notOwingmembers) {
          setState(() {
            sendMessagesIds.add(id.added!);
          });
        }
      }
    } else if (_selectedMember == 'Selecte Members') {
      if (sendMessagesIds.isEmpty) {
        for (var id in selected4Message) {
          setState(() {
            sendMessagesIds.add(id.id!);
          });
        }
      }
    }

    for (var mem in sendMessagesIds) {
      QuerySnapshot snapchatroom = await FirebaseFirestore.instance
          .collection('chatroom')
          .where('members', arrayContains: mem)
          .get();
      if (snapchatroom.docs.isNotEmpty) {
        ChatroomModel model = ChatroomModel.fromMap(
            snapchatroom.docs.first.data() as Map<String, dynamic>);
        //arranging messages
        Map<String, dynamic> messages = {
          "sendby": user.uid,
          'sendto': mem,
          "message": _message.text,
          "type": "text",
          "time": FieldValue.serverTimestamp(),
        };
        final newMessage = FirebaseFirestore.instance
            .collection('chatroom')
            .doc(model.id)
            .collection('chats')
            .doc();
        await newMessage.set(messages);
      } else {
        final newChatRoom =
            FirebaseFirestore.instance.collection('chatroom').doc();
        ChatroomModel newchat =
            ChatroomModel(id: newChatRoom.id, members: [user.uid, mem]);
        await newChatRoom.set(newchat.toMap());
        //arranging messages
        Map<String, dynamic> messages = {
          "sendby": user.uid,
          'sendto': mem,
          "message": _message.text,
          "type": "text",
          "time": FieldValue.serverTimestamp(),
        };
        final newMessage = FirebaseFirestore.instance
            .collection('chatroom')
            .doc(newChatRoom.id)
            .collection('chats')
            .doc();
        await newMessage.set(messages);
      }
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Alert'),
              content: Text('Message successfully sent'),
              actions: [
                CloseButton(),
              ],
            );
          });
    }
    setState(() {
      isLoading = false;
      _message.clear();
    });
  }
}
