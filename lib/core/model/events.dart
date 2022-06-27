import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String id;
  //use [programmeId] if upon consultation, an event can span over multiple programmes
  //List<String> programmeId;
  final String programmeTag;
  final String name;
  final String? description;
  final String? image;
  final bool isAttendable;
  final List<String> registeredUsers;
  final DateTime startDate;
  final DateTime endDate;
  final String? location;
  final String? organizedBy;
  Event(
      {required this.id,

      /// required this.programmeId,
      required this.programmeTag,
      required this.name,
      this.description,
      this.image,
      this.isAttendable = false,
      required this.startDate,
      this.location,
      this.organizedBy,
      required this.endDate,
      required this.registeredUsers});

  factory Event.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    List<dynamic> registeredUsers = data['registeredUsers'];
    return Event(
      id: data['id'],
      //programmeId: data['programmeId'],
      programmeTag: data['programmeTag'],
      name: data['name'],
      description: data['description'],
      image: data['image'],
      isAttendable: data['isAttendable'],
      registeredUsers: registeredUsers
          .map((registeredUser) => registeredUser.toString())
          .toList(),
      startDate: data['startDate'].toDate(),

      endDate: data['endDate'].toDate(),
      location: data['location'],
      organizedBy: data['organizedBy'],
    );
  }
  factory Event.fromAPI(Map data) {
    return Event(
      id: data['id'],
      // programmeId: data['programmeId'],
      name: data['name'],
      programmeTag: data['programmeTag'],
      description: data['description'],
      image: data['image'],
      isAttendable: data['isAttendable'],
      registeredUsers: data['registeredUsers'],
      startDate: data['startDate'].toDate(),
      endDate: data['endDate'].toDate(),
      location: data['location'],
      organizedBy: data['organizedBy'],
    );
  }
}
