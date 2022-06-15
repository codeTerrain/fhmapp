import 'package:fhmapp/ui/viewmodels/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../core/model/chat_item_model.dart';
import '../../core/services/respository.dart';
import '../../locator.dart';
import '../widgets/appbars.dart';
import '../widgets/misc.dart';
import '../widgets/notification_count.dart';
import '../widgets/chat_user_tile.dart';
import 'national_rep_chat.dart';

class ChatUsers extends StatefulWidget {
  final String category;

  const ChatUsers({Key? key, required this.category}) : super(key: key);

  @override
  State<ChatUsers> createState() => _ChatUsersState();
}

class _ChatUsersState extends State<ChatUsers> {
  final Respository _respository = locator<Respository>();

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
    return Scaffold(
      body: CustomScrollView(
        physics: scrollPhysics,
        slivers: [
          SearchAppBar(searchController: _searchController, filter: _filter),
          StreamBuilder<List<ChatItemModel>>(
              stream: _respository.getLastChats(widget.category),
              builder: (context, snapshot) {
                List<ChatItemModel>? chatItem = snapshot.data;

                if (!snapshot.hasData) {
                  return circularProgressIndicator;
                } else {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ChatUserTile(
                            index,
                            chatItem![index],
                            trailing: NotificationCount(
                                category: widget.category,
                                chatUserId: chatItem[index].userId,
                                userType: 'nationalRep'),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      ViewModelBuilder<
                                              ProfileViewModel>.reactive(
                                          viewModelBuilder: () =>
                                              ProfileViewModel(),
                                          onModelReady: (model) =>
                                              model.getUserInfo(),
                                          builder: (context, model, child) {
                                            if (model.isBusy) {
                                              return Container();
                                            } else {
                                              return NationalRepChat(
                                                category: widget.category,

                                                ///id of normal user -- This is retrieved from the chatUserId field of last chat
                                                chatUserId:
                                                    chatItem[index].chatUserId,
                                                //id of nationalRep(currentUser)
                                                currentUser: model.user,
                                              );
                                            }
                                          })),
                            ),
                          ),
                        );
                      },
                      childCount: chatItem!.length,
                    ),
                  );
                }
              })

          // ),
        ],
      ),
    );
  }
}
