import 'package:flutter/material.dart';

import '../shared/static_lists.dart';
import '../widgets/appbars.dart';
import '../widgets/misc.dart';
import '../widgets/notification_count.dart';
import '../widgets/program_tile.dart';
import 'chat.dart';

class ChatCategory extends StatelessWidget {
  const ChatCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: scrollPhysics,
      slivers: [
        const SearchAppBar(),
        // SliverPadding(
        //   padding: const EdgeInsets.symmetric(horizontal: 30),
        //   sliver:
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ProgramTile(
                  index,
                  trailing: const NotificationCount(),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          Chat(category: programs.keys.toList()[index]),
                    ),
                  ),
                ),
              );
            },
            childCount: 4,
          ),
        ),
        // ),
      ],
    );
  }
}
