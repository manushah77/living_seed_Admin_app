import 'package:cloud_firestore/cloud_firestore.dart';

class DataModel {
  final String? name;
  final String? developer;
  final String? framework;
  final String? image;

  DataModel({this.name, this.developer, this.framework, this.image});

  List<DataModel> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap =
      snapshot.data() as Map<String, dynamic>;

      return DataModel(
          name: dataMap['fname'],
          developer: dataMap['email'],
          image : dataMap['lname'],
      );

    }).toList();
  }
}
