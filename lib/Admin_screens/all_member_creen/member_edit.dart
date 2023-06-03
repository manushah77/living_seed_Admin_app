import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/cateogryModel.dart';
import '../../models/members.dart';
import '../welcome_back_screen.dart';

class MemberEdit extends StatefulWidget {
  final MemberData data;
  const MemberEdit({Key? key, required this.data}) : super(key: key);

  @override
  State<MemberEdit> createState() => _MemberEditState();
}

class _MemberEditState extends State<MemberEdit> {
  List<CategoryModel> category = [];
  List<CategoryModel> allcategory = [];
  Future getCategory() async {
    for (var item in widget.data.categories!) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Categories')
          .where('id', isEqualTo: item)
          .get();
      if (snapshot.docs.isNotEmpty) {
        CategoryModel model = CategoryModel.fromMap(
            snapshot.docs.first.data() as Map<String, dynamic>);
        setState(() {
          category.add(model);
        });
      }
    }
    QuerySnapshot snapshotcat =
        await FirebaseFirestore.instance.collection('Categories').get();
    setState(() {
      allcategory = snapshotcat.docs
          .map((e) => CategoryModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();
    });
  }

  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  //TextEditingController clas = TextEditingController();
  TextEditingController phn = TextEditingController();
  @override
  void initState() {
    super.initState();
    fname.text = widget.data.fname!;
    lname.text = widget.data.lname!;
    phn.text = widget.data.phone!;
    getCategory();
    //clas.text = widget.data.classType!;
  }

  @override
  Widget build(BuildContext context) {
    var screesize = MediaQuery.of(context).size;
    return Scaffold(
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
                "MEMBER DETAIL",
                style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontWeight: FontWeight.w600,
                    fontSize: 20),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //fname

              Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 20, top: 10),
                child: Container(
                  height: screesize.height / 14,
                  width: screesize.width / 1,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0.3, 2)),
                    ],
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(right: 20.0, left: 20, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(3.0),
                          child: SizedBox(
                            width: 200,
                            child: TextFormField(
                              cursorColor: const Color(0xff83050C),
                              cursorHeight: 20,
                              decoration: InputDecoration(
                                hintText: 'First Name',
                                hintStyle: const TextStyle(
                                  color: Color(0xffC4C4C4),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xff83050C), width: 1.0),
                                    borderRadius: BorderRadius.circular(10)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xff83050C), width: 1.0),
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              controller: fname,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                FirebaseFirestore.instance
                                    .collection('Members')
                                    .doc(widget.data.added)
                                    .update({
                                  "fname": fname.text,
                                }).whenComplete(() => showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              content:
                                                  Text('Update Succesfull'),
                                              actions: [CloseButton()],
                                            )));
                              },
                              child: const Text(
                                'Update',
                                style: TextStyle(
                                    color: Color(0xff939393),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),

              //lname

              Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 20, top: 10),
                child: Container(
                  height: screesize.height / 14,
                  width: screesize.width / 1,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0.3, 2)),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(3.0),
                          child: SizedBox(
                            width: 200,
                            child: TextFormField(
                              cursorColor: const Color(0xff83050C),
                              cursorHeight: 20,
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                                hintStyle: const TextStyle(
                                  color: Color(0xffC4C4C4),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xff83050C), width: 1.0),
                                    borderRadius: BorderRadius.circular(10)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xff83050C), width: 1.0),
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              controller: lname,
                            ),
                          ),
                        ),
                        // Text(
                        //   lname.text.isEmpty ? '${widget.data.lname}' : lname.text,
                        //   style: const TextStyle(
                        //       color: Color(0xff83050C), fontSize: 16, fontWeight: FontWeight.w700),
                        // ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                FirebaseFirestore.instance
                                    .collection('Members')
                                    .doc(widget.data.added)
                                    .update({
                                  "lname": lname.text,
                                }).whenComplete(() => showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              content:
                                                  Text('Update Succesfull'),
                                              actions: [CloseButton()],
                                            )));
                              },
                              child: const Text(
                                'Update',
                                style: TextStyle(
                                    color: Color(0xff939393),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),

              //phone number

              Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 20, top: 10),
                child: Container(
                  height: screesize.height / 14,
                  width: screesize.width / 1,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0.3, 2)),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(3.0),
                          child: SizedBox(
                            width: 200,
                            child: TextFormField(
                              cursorColor: const Color(0xff83050C),
                              cursorHeight: 20,
                              decoration: InputDecoration(
                                labelText: 'Phone',
                                hintStyle: const TextStyle(
                                  color: Color(0xffC4C4C4),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xff83050C), width: 1.0),
                                    borderRadius: BorderRadius.circular(10)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xff83050C), width: 1.0),
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              controller: phn,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                FirebaseFirestore.instance
                                    .collection('Members')
                                    .doc(widget.data.added)
                                    .update({
                                  "Phone Number": phn.text,
                                })
                                  ..whenComplete(() => showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            content: Text('Update Succesfull'),
                                            actions: [CloseButton()],
                                          )));
                              },
                              child: const Text(
                                'Update',
                                style: TextStyle(
                                    color: Color(0xff939393),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text('Already Selected Categories'),
              ),
              Padding(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                  child: Container(
                    height: 200,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: ListView.builder(
                        itemCount: category.isEmpty ? 0 : category.length,
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (context, index) {
                          return categoryItem(category[index], index);
                        }),
                  )),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text('Add More Categories'),
              ),
              Padding(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                  child: Container(
                    height: 200,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: ListView.builder(
                        itemCount: allcategory.isEmpty ? 0 : allcategory.length,
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (context, index) {
                          return categoryItemNew(allcategory[index], index);
                        }),
                  )),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ));
  }

  Widget categoryItem(CategoryModel _category, int index) {
    return Container(
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: Colors.red)),
        padding: const EdgeInsets.only(
            top: 1.0, bottom: 1.0, left: 30.0, right: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(_category.categoryName!),
            ),
            TextButton(
                onPressed: () async {
                  final delDoc = FirebaseFirestore.instance
                      .collection('Members')
                      .doc(widget.data.added);
                  await delDoc.update({
                    'categories': FieldValue.arrayRemove([_category.id])
                  });
                  setState(() {
                    category.removeAt(index);
                  });
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            content: Text('Category Removed'),
                            actions: [CloseButton()],
                          ));
                },
                child: Text(
                  'Remove',
                  style: TextStyle(color: Colors.red),
                ))
          ],
        ));
  }

  Widget categoryItemNew(CategoryModel _category, int index) {
    return Container(
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: Colors.green)),
        padding: const EdgeInsets.only(
            top: 1.0, bottom: 1.0, left: 30.0, right: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(_category.categoryName!),
            ),
            TextButton(
                onPressed: () async {
                  QuerySnapshot sanp = await FirebaseFirestore.instance
                      .collection('Members')
                      .where('categories', arrayContains: _category.id)
                      .where('Added', isEqualTo: widget.data.added)
                      .get();
                  if (sanp.docs.isNotEmpty) {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              content: Text('Category Already Present'),
                              actions: [CloseButton()],
                            ));
                  } else {
                    final delDoc = FirebaseFirestore.instance
                        .collection('Members')
                        .doc(widget.data.added);
                    await delDoc.update({
                      'categories': FieldValue.arrayUnion([_category.id])
                    });
                    setState(() {
                      allcategory.removeAt(index);
                      category.add(_category);
                    });
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              content: Text('Category Added'),
                              actions: [CloseButton()],
                            ));
                  }
                },
                child: Text(
                  'Add',
                  style: TextStyle(color: Colors.green),
                ))
          ],
        ));
  }
}


// class CategoryWidget extends StatefulWidget {
//   CategoryModel model
//   const CategoryWidget({super.key});

//   @override
//   State<CategoryWidget> createState() => _CategoryWidgetState();
// }

// class _CategoryWidgetState extends State<CategoryWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
