import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

import '../model/user_model.dart';

class Respository {
  static final Respository _instance = Respository.internal();
  factory Respository() => _instance;
  Respository.internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<QueryDocumentSnapshot> getUser(String email) async {
    QuerySnapshot qs = await _db
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    return qs.docs.first;
  }

  Future<Users> getUserDetail(String email) async {
    var userDoc = await getUser(email);
    var userDocMap = userDoc.data() as Map;

    return Users.fromJson(userDocMap, userDoc.id);
  }

  updateToken(
      {required String email,
      required Set<String> updatedLoggedInDevices}) async {
    var userDoc = await getUser(email);
    DocumentReference userDocRef = userDoc.reference;

    userDocRef.update({'loggedInDevices': updatedLoggedInDevices.toList()});
  }

  userOnlineState({required String email, required bool online}) async {
    var userDoc = await getUser(email);
    DocumentReference userDocRef = userDoc.reference;
    userDocRef.update({'onlineStatus': online});
  }

  Future<ListResult> getResource(String category) {
    return _storage.ref('/resources/$category').listAll();
  }

  Future getResources(String category) async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('resources')
          .where('category', isEqualTo: category)
          .get();
      return querySnapshot;
    } catch (e) {
      if (e is PlatformException) {
        return e.details;
      }

      return e.toString();
    }
  }

  Future getCourses() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection('courses').get();
      return querySnapshot;
    } catch (e) {
      if (e is PlatformException) {
        return e.details;
      }

      return e.toString();
    }
  }
}
