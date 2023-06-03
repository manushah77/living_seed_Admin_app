import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AdminChatRoom extends StatefulWidget {
  // final Map<String, dynamic> userMap;

  final String chatRoomId;
  final String docId;
  final String userId;
  final String name;
  final String? image;

  AdminChatRoom(
      {required this.chatRoomId,
      required this.docId,
      required this.name,
      required this.userId,
      this.image});

  @override
  State<AdminChatRoom> createState() => _AdminChatRoomState();
}

class _AdminChatRoomState extends State<AdminChatRoom> {
  final TextEditingController _message = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  File? imageFile;

  Future getImage() async {
    ImagePicker _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    String fileName = Uuid().v1();
    int status = 1;
    await _firestore.collection('chatroom').doc(widget.chatRoomId).set({
      'firstParticpantId': widget.docId,
      'secondParticipantId': widget.userId,
    });

    await _firestore
        .collection('chatroom')
        .doc(widget.chatRoomId)
        .collection('chats')
        .doc(widget.docId)
        .set({
      "sendby": widget.docId,
      "sendto": widget.userId,
      "message": "",
      "type": "img",
      "time": FieldValue.serverTimestamp(),
    });

    var ref =
        FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");

    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      await _firestore
          .collection('chatroom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .doc(fileName)
          .delete();

      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();

      await _firestore
          .collection('chatroom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .doc(fileName)
          .update({"message": imageUrl});
    }
  }

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": widget.docId,
        'sendto': widget.userId,
        "message": _message.text,
        "type": "text",
        'isRead': false,
        "time": FieldValue.serverTimestamp(),
      };

      _message.clear();
      await _firestore
          .collection('chatroom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .add(messages)
          .then((value) {
        // _firestore
        //     .collection('chatroom')
        //     .doc(widget.chatRoomId)
        //     .set({'last': _message.text, 'seen': true});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Color(0xFF83050C),
            statusBarIconBrightness:
                Brightness.light, // For Android (dark icons)
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF83050C),
          elevation: 0,
          title: Text(widget.name)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              height: size.height / 1.25,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chatroom')
                    .doc(widget.chatRoomId)
                    .collection('chats')
                    .orderBy("time", descending: false)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    // print( '${snapshot.data!.docs.length} hello');
                    return ListView.builder(
                      reverse: true,
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> map = snapshot.data!.docs.reversed
                            .toList()[index]
                            .data() as Map<String, dynamic>;
                        // _firestore
                        //     .collection('chatroom')
                        //     .doc(widget.chatRoomId)
                        //     .collection('chats')
                        //     .get()
                        //     .then((value) {
                        //   value.docs.forEach((doc) {
                        //     doc.reference.update({'isRead': true});
                        //   });
                        // });

                        return messages(size, map, context);
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Container(
              height: size.height / 14.5,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                height: size.height / 12,
                width: size.width / 1.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: size.height / 17,
                      width: size.width / 1.3,
                      child: TextField(
                        cursorColor: Color(0xFF83050C),
                        controller: _message,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(5),
                          // suffixIcon: IconButton(
                          //   onPressed: () => getImage(),
                          //   icon: Icon(Icons.photo),
                          //   color: Color(0xFFFF7F27),
                          // ),
                          hintText: "Send Message",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: Color(0xFF83050C), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: Color(0xFF83050C), width: 1),
                          ),
                        ),
                        maxLength: null,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: Color(0xFF83050C),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.send,
                          size: 17,
                        ),
                        onPressed: onSendMessage,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {
    return map['type'] == 'text'
        ? Container(
            width: MediaQuery.of(context).size.width,
            alignment: map['sendby'] == widget.docId
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: map['sendby'] == widget.docId
                      ? Color(0xFF83050C)
                      : Colors.black38),
              child: Text(
                map['message'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          )
        : Positioned(
            top: 100,
            child: Container(
              height: size.height / 2.5,
              width: size.width,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              alignment: map['sendby'] == widget.docId
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ShowImage(
                      imageUrl: map['message'],
                    ),
                  ),
                ),
                child: Container(
                  height: size.height / 2.5,
                  width: size.width / 2,
                  decoration: BoxDecoration(border: Border.all()),
                  alignment: map['message'] != "" ? null : Alignment.center,
                  child: map['message'] != ""
                      ? Image.network(
                          map['message'],
                          fit: BoxFit.cover,
                        )
                      : CircularProgressIndicator(),
                ),
              ),
            ),
          );
  }
}

class ShowImage extends StatelessWidget {
  final String imageUrl;

  const ShowImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Image.network(imageUrl),
      ),
    );
  }
}
