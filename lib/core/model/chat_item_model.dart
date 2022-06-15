import 'package:cloud_firestore/cloud_firestore.dart';

class ChatItemModel {
  final String id;
  final String? chatUserName;
  final String chatUserId;
  final int createdAt;

  final String text;
  final String userFirstName;
  final String userLastName;
  final String userId;
  final String userType;

  ChatItemModel(
      {required this.createdAt,
      required this.text,
      required this.chatUserName,
      required this.chatUserId,
      required this.id,
      required this.userId,
      required this.userLastName,
      required this.userType,
      required this.userFirstName});

  factory ChatItemModel.fromFirestore(DocumentSnapshot<Map> doc) {
    Map? data = doc.data();

    return ChatItemModel(
      createdAt: data!['createdAt'],
      chatUserName: data['chatUserName'],
      chatUserId: data['chatUserId'] ?? '',
      id: data['id'],
      text: data['text'],
      userFirstName: data['user']['firstName'],
      userLastName: data['user']['lastName'],
      userId: data['user']['uid'],
      userType: data['user']['name'],
    );
  }
}
