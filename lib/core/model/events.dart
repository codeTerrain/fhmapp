import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Event {
  String id;
  List<String> programmeId;
  String name;
  String? description;
  String? image;
  bool isAttendable;
  List<User>? registeredUsers;
  DateTime? startDate;
  DateTime? endDate;
  String? location;
  String? organizedBy;
  Event(
      {required this.id,
      required this.programmeId,
      required this.name,
      this.description,
      this.image,
      this.isAttendable = false,
      this.startDate,
      this.location,
      this.organizedBy,
      this.endDate,
      this.registeredUsers});

  factory Event.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Event(
      id: data['id'],
      programmeId: data['programmeId'],
      name: data['name'],
      description: data['description'],
      image: data['image'],
      isAttendable: data['isAttendable'],
      registeredUsers: data['registeredUsers'],
      startDate: data['startDate'],
      endDate: data['endDate'],
      location: data['location'],
      organizedBy: data['organizedBy'],
    );
  }
  factory Event.fromAPI(Map data) {
    return Event(
      id: data['id'],
      programmeId: data['programmeId'],
      name: data['name'],
      description: data['description'],
      image: data['image'],
      isAttendable: data['isAttendable'],
      registeredUsers: data['registeredUsers'],
      startDate: data['startDate'],
      endDate: data['endDate'],
      location: data['location'],
      organizedBy: data['organizedBy'],
    );
  }
}
