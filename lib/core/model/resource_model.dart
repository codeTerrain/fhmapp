import 'package:cloud_firestore/cloud_firestore.dart';

class Resource {
  final String path;
  final String name;
  final String extension;
  final String category;
  final bool isRemote;

  Resource(
      {required this.path,
      required this.name,
      required this.category,
      required this.extension,
      required this.isRemote});

  factory Resource.fromFireStore(DocumentSnapshot<Map> doc) {
    Map? data = doc.data();

    return Resource(
      path: data!['path'],
      name: data['name'],
      category: data['category'],
      extension: data['extension'],
      isRemote: data['extension'],
    );
  }

  factory Resource.fromAPI(Map data) {
    return Resource(
        path: data['path'],
        name: data['name'],
        category: data['category'],
        extension: data['extension'],
        isRemote: data['isRemote']);
  }
}
