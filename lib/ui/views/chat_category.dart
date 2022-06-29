import 'package:fhmapp/ui/viewmodels/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../shared/static_lists.dart';
import '../widgets/appbars.dart';
import '../widgets/misc.dart';
import '../widgets/notification_count.dart';
import '../widgets/tiles.dart';
import 'chat_users.dart';
import 'user_chat.dart';

class ChatCategory extends StatefulWidget {
  const ChatCategory({Key? key}) : super(key: key);

  @override
  State<ChatCategory> createState() => _ChatCategoryState();
}

class _ChatCategoryState extends State<ChatCategory> {
  String? _filter;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _filter = _searchController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(physics: scrollPhysics, slivers: [
      SearchAppBar(searchController: _searchController, filter: _filter),
      ViewModelBuilder<ProfileViewModel>.reactive(
          viewModelBuilder: () => ProfileViewModel(),
          onModelReady: (model) => model.getUserInfo(),
          builder: (context, model, child) {
            if (model.isBusy) {
              return circularProgressIndicator;
            } else {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (_filter == null ||
                        programs.keys
                            .toList()[index]
                            .toLowerCase()
                            .contains(_filter!.toLowerCase()) ||
                        programs.values
                            .toList()[index]
                            .toLowerCase()
                            .contains(_filter!.toLowerCase())) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ProgramTile(
                          index,
                          id: programs.keys.toList()[index],
                          text: programs.values.toList()[index],
                          trailing: model.user.userType != 'nationalRep'
                              ? NotificationCount(
                                  category: programs.keys.toList()[index],
                                  chatUserId: model.user.userId,
                                  userType: model.user.userType,
                                )
                              : const SizedBox(),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => model
                                          .user.userType ==
                                      'nationalRep'
                                  ? ChatUsers(
                                      category: programs.keys.toList()[index],
                                    )
                                  : UserChat(
                                      category: programs.keys.toList()[index],
                                      currentUser: model.user),
                            ),
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                  childCount: 4,
                ),
              );
            }
          })
    ]);
  }
}
