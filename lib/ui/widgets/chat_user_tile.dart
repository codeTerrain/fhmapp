import 'package:flutter/material.dart';

import '../../core/model/chat_item_model.dart';
import '../shared/style.dart';
import 'misc.dart';

class ChatUserTile extends StatelessWidget {
  final int index;
  final ChatItemModel chatItem;
  final GestureTapCallback? onTap;
  final Widget? trailing;
  const ChatUserTile(this.index, this.chatItem,
      {Key? key, this.onTap, this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        shape: roundedListTileBorder,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        tileColor: kWhite,
        leading: const CircleAvatar(
          child: Icon(
            Icons.person,
            color: kWhite,
          ),
          backgroundColor: primaryColor,
        ),
        title: Text(
          chatItem.chatUserName ?? 'User $index',
          style: Theme.of(context).textTheme.bodyText1?.copyWith(color: grey),
        ),
        trailing: trailing,
        onTap: onTap);
  }
}
