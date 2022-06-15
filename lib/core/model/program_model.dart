import 'package:cloud_firestore/cloud_firestore.dart';

class Program {
  String id;
  String name;
  String image;
  bool isSelected;
  Program(
      {required this.id,
      required this.name,
      this.isSelected = false,
      required this.image});

  factory Program.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Program(
      isSelected: data['isSelected'],
      id: data['id'],
      name: data['name'],
      image: data['image'],
    );
  }
}
