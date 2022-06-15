import 'package:fhmapp/core/model/chat_item_model.dart';
import 'package:flutter/material.dart';

import '../../core/services/respository.dart';
import '../../locator.dart';
import '../shared/style.dart';

class NotificationCount extends StatelessWidget {
  final Respository _respository = locator<Respository>();
  final String category;
  final String chatUserId;
  final String userType;
  NotificationCount(
      {required this.category,
      required this.chatUserId,
      required this.userType,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ChatItemModel>>(
        stream: _respository.getUnreadChats(category, chatUserId, userType),
        builder: (context, snapshot) {
          List<ChatItemModel>? chatItem = snapshot.data;
          if (!snapshot.hasData || chatItem!.isEmpty) {
            return const SizedBox();
          } else {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 6),
              decoration: BoxDecoration(
                  color: primaryColor, borderRadius: BorderRadius.circular(10)),
              child: Text(
                chatItem.length.toString(),
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    ?.copyWith(color: kWhite),
              ),
            );
          }
        });
  }
}
