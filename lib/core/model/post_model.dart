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
}

List<Post> dummyPosts = [
  Post(
      postId: '1',
      category: 'Adolescent Health',
      content: 'Every day is a good day to be healthy',
      date: DateTime(2022, 3, 15),
      images: [
        'assets/images/dashboard/dummyFamily.png',

        'assets/images/dashboard/dummyFamily.png',

        'assets/images/dashboard/dummyFamily.png',
        // fit: BoxFit.fitWidth,
      ],
      likes: [
        'PedHu77dM0fVk1sGzniCZifIEHf1'
      ]),
  Post(
      postId: '2',
      category: 'Family Planning',
      content: 'Contraceptives are vital in the prevention of pregnancy',
      date: DateTime(2020, 4, 5),
      likes: []),
  Post(
      postId: '3',
      category: 'Nutrition',
      content: 'Eat right, stay healthy. Nothing beats that',
      images: [
        'assets/images/dashboard/dummyFamily.png',
      ],
      date: DateTime(2021, 3, 15),
      likes: [])
];
