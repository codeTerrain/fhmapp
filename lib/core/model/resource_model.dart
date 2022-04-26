import 'package:cloud_firestore/cloud_firestore.dart';

class ResourceModel {
  final String path;
  final String name;
  final String extension;
  final String category;
  final bool isRemote;

  ResourceModel(
      {required this.path,
      required this.name,
      required this.category,
      required this.extension,
      required this.isRemote});

  factory ResourceModel.fromFireStore(DocumentSnapshot<Map> doc) {
    Map? data = doc.data();

    return ResourceModel(
      path: data!['path'],
      name: data['name'],
      category: data['category'],
      extension: data['extension'],
      isRemote: data['extension'],
    );
  }

  factory ResourceModel.fromAPI(Map data) {
    return ResourceModel(
        path: data['path'],
        name: data['name'],
        category: data['category'],
        extension: data['extension'],
        isRemote: data['isRemote']);
  }
}
