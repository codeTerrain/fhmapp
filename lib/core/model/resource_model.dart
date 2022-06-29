import 'package:cloud_firestore/cloud_firestore.dart';

class Resource {
  final String id;
  final String path;
  final String name;
  final String extension;
  final String category;
  final bool isRemote;
  final List<String>? downloadedUsers;

  Resource({
    required this.path,
    required this.id,
    required this.name,
    required this.category,
    required this.isRemote,
    required this.extension,
    required this.downloadedUsers,
  });

  factory Resource.fromFireStore(DocumentSnapshot<Map> doc) {
    Map? data = doc.data();
    List<dynamic> downloadedUsers = data!['downloadedUsers'];
    return Resource(
      id: data['id'].toString(),
      path: data['path'],
      name: data['name'],
      category: data['category'],
      isRemote: data['isRemote'],
      extension: data['extension'],
      downloadedUsers: downloadedUsers
          .map((downloadedUser) => downloadedUser.toString())
          .toList(),
    );
  }

  factory Resource.fromAPI(Map data) {
    return Resource(
        id: data['id'].toString(),
        path: data['path'],
        name: data['name'],
        category: data['category'],
        isRemote: data['isRemote'],
        downloadedUsers: data['downloadedUsers'],
        extension: data['extension']);
  }
}
