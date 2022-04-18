import 'package:flutter/material.dart';

class Post {
  final String postId;
  final String category;
  final String? content;
  final DateTime date;
  final List<Widget>? images;
  final bool isLiked;

  Post(
      {required this.postId,
      required this.category,
      this.content,
      required this.date,
      this.images,
      required this.isLiked});
}

List<Post> dummyPosts = [
  Post(
      postId: '1',
      category: 'Adolescent Health',
      content: 'Every day is a good day to be healthy',
      date: DateTime(2022, 3, 15),
      images: [
        Image.asset(
          'assets/images/dashboard/dummyFamily.png',
          //scale: 3,
          fit: BoxFit.fitWidth,
        ),
        Image.asset(
          'assets/images/dashboard/dummyFamily.png',
          fit: BoxFit.fitWidth,
          scale: 3,
        ),
        Image.asset(
          'assets/images/dashboard/dummyFamily.png',
          fit: BoxFit.fitWidth,
        )
      ],
      isLiked: true),
  Post(
      postId: '2',
      category: 'Family Planning',
      content: 'Contraceptives are vital in the prevention of pregnancy',
      date: DateTime(2020, 4, 5),
      isLiked: true),
  Post(
      postId: '3',
      category: 'Nutrition',
      content: 'Eat right, stay healthy. Nothing beats that',
      images: [
        Image.asset(
          'assets/images/dashboard/dummyFamily.png',
          fit: BoxFit.fitWidth,
        )
      ],
      date: DateTime(2021, 3, 15),
      isLiked: true)
];
