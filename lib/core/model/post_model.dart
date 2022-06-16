import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Post {
  final String postId;
  final String category;
  final String? content;
  final DateTime date;
  final List<String>? images;
  final List<String> likes;

  Post(
      {required this.postId,
      required this.category,
      this.content,
      required this.date,
      this.images,
      required this.likes});

  factory Post.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map? data = doc.data();
    List<dynamic> fireStoreLikes = data!['likes'];
    List<dynamic> fireStoreImages = data['images'];

    return Post(
      postId: data['postId'],
      category: data['category'],
      content: data['content'],
      date: DateTime.fromMillisecondsSinceEpoch(int.parse(data['postId'])),
      images: fireStoreImages
          .map((fireStoreImage) => fireStoreImage.toString())
          .toList(),
      likes: fireStoreLikes
          .map((fireStoreLike) => fireStoreLike.toString())
          .toList(),
    );
  }
}
