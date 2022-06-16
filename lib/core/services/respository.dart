import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fhmapp/core/model/facility_model.dart';
import 'package:fhmapp/core/model/post_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

import '../model/chat_item_model.dart';
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

  updateToken({
    String? token,
    required String email,
    required Set<String> updatedLoggedInDevices,
  }) async {
    var userDoc = await getUser(email);
    DocumentReference userDocRef = userDoc.reference;
    List<String>? distinctDevices;

    if (updatedLoggedInDevices.isEmpty) {
      List<String> getAllLoggedInDevices =
          List<String>.from(userDoc['loggedInDevices']);
      getAllLoggedInDevices.remove(token);

      distinctDevices = getAllLoggedInDevices.toSet().toList();
    } else {
      distinctDevices = updatedLoggedInDevices.toList();
    }
    userDocRef.update({'loggedInDevices': distinctDevices});
  }

  userOnlineState({required String email, required bool online}) async {
    var userDoc = await getUser(email);
    DocumentReference userDocRef = userDoc.reference;
    userDocRef.update({'onlineStatus': online});
  }

  updateInfo(String email, Map<String, dynamic> data) async {
    try {
      var userDoc = await getUser(email);
      DocumentReference userDocRef = userDoc.reference;
      userDocRef.update(data).timeout(const Duration(minutes: 3));
      return true;
    } catch (e) {
      return false;
    }
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

  Future addMessage(String chatRoomId, Map<String, dynamic> messageItem) async {
    var addCompleteChat =
        _db.collection('FHMAppChat').doc(chatRoomId).collection('chats').doc();
    var addLastMessage = _db.collection('FHMAppChat').doc(chatRoomId);
    DocumentSnapshot<Map<String, dynamic>> getLastMessage =
        await addLastMessage.get();
    if (!getLastMessage.exists) {
      return _db.runTransaction((transaction) async {
        transaction
            .set(
              addCompleteChat,
              messageItem,
            )
            .set(addLastMessage, messageItem);
      });
    } else {
      return _db.runTransaction((transaction) async {
        transaction
            .set(
              addCompleteChat,
              messageItem,
            )
            .update(addLastMessage, messageItem);
      });
    }
  }

  Future addPost(Map<String, dynamic> postItem) async {
    var addPost = _db.collection('posts').doc();

    return _db.runTransaction((transaction) async {
      transaction.set(
        addPost,
        postItem,
      );
    });
  }

  Stream<QuerySnapshot> getMessages(String chatRoomId) {
    Stream<QuerySnapshot> query = _db
        .collection('FHMAppChat')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy('createdAt')
        .snapshots();

    return query;
  }

  Stream<List<ChatItemModel>> getLastChats(String category) {
    Stream<List<ChatItemModel>> query = _db
        .collection('FHMAppChat')
        .orderBy('createdAt')
        .where('id', isEqualTo: category)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((document) => ChatItemModel.fromFirestore(document))
            .toList());

    return query;
  }

  Stream<List<ChatItemModel>> getUnreadChats(
      String category, String chatUserId, String userType) {
    CollectionReference<Map<dynamic, dynamic>> collectionRef = _db
        .collection('FHMAppChat')
        .doc(category + '_' + chatUserId)
        .collection('chats');
    if (userType == 'nationalRep') {
      Stream<List<ChatItemModel>> query = collectionRef
          .where('isRead', isEqualTo: false)
          .where('user.uid', isEqualTo: chatUserId)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((document) => ChatItemModel.fromFirestore(document))
              .toList());

      return query;
    } else {
      Stream<List<ChatItemModel>> query = collectionRef
          .where('readByUser', isEqualTo: false)
          .where('user.uid', isNotEqualTo: chatUserId)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((document) => ChatItemModel.fromFirestore(document))
              .toList());

      return query;
    }
  }

  Future<Users> setUserDetails(Map<String, dynamic> data) async {
    final DocumentReference user = _db.collection('users').doc();

    await user.set(data);
    return Users.fromSignUp(data, user.id);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> userSnapshots(
      String userDocId) {
//String userDocId =   _respository.getLocalStorage('userDocId');
    return _db.collection('users').doc(userDocId).snapshots();
  }

  Stream<List<Facility>> getFacilities() {
    Stream<List<Facility>> facilities = _db
        .collection('facilities')
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((document) {
              // print(snapshot);
              return Facility.fromFirestore(document);
            }).toList());

    return facilities;
  }

  Stream<List<Post>> getPosts() {
    Stream<List<Post>> posts = _db
        .collection('posts')
        .orderBy('postId', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((document) {
              return Post.fromFirestore(document);
            }).toList());

    return posts;
  }

  Future<QueryDocumentSnapshot> getPost(String postId) async {
    QuerySnapshot qs = await _db
        .collection('posts')
        .where('postId', isEqualTo: postId)
        .limit(1)
        .get();

    return qs.docs.first;
  }

  updateLikes({
    required String postId,
    required String email,
    required Set<String> updatedLikes,
  }) async {
    var postDoc = await getPost(postId);
    DocumentReference postDocRef = postDoc.reference;
    List<String>? distinctLikes;
    // print(updatedLikes);
    if (!updatedLikes.contains(email)) {
      List<String> onlinePostLikes = List<String>.from(postDoc['likes']);

      onlinePostLikes.remove(email);

      distinctLikes = onlinePostLikes.toSet().toList();
    } else {
      distinctLikes = updatedLikes.toList();
    }
    postDocRef.update({'likes': distinctLikes});
  }
}
