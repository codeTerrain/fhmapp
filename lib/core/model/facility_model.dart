import 'package:cloud_firestore/cloud_firestore.dart';

class Facility {
  final String name;
  final String placeId;
  final String address;
  final String type;
  final List<Contact>? contact;
  final List<dynamic> services;

  final GeoPoint location;

  Facility({
    required this.name,
    required this.placeId,
    required this.address,
    required this.type,
    required this.services,
    required this.contact,
    required this.location,
  });

  factory Facility.fromJson(Map<dynamic, dynamic> data, String docId) =>
      Facility(
        // placeId: docId,
        placeId: data['placeId'],
        name: data['name'],
        address: data['address'],
        location: data['location'],
        contact: data['contact'],
        type: data['type'],
        services: data['services'],
      );

  factory Facility.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map? data = doc.data();
    List<dynamic> fireStoreContacts = data!['contact'];

    return Facility(
      // userDocId: doc.id,
      placeId: data['placeId'],
      name: data['name'],
      address: data['address'],
      location: data['location'],
      type: data['type'],
      contact: fireStoreContacts
          .map((fireStoreContact) =>
              Contact(fireStoreContact['name'], fireStoreContact['phone']))
          .toList(),
      services: data['services'],
    );
  }
}

class Contact {
  final String name;
  final String phone;

  Contact(this.name, this.phone);
}
