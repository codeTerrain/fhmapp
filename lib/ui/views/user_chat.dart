import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fhmapp/core/model/user_model.dart';
import 'package:fhmapp/ui/shared/spacing.dart';
import 'package:fhmapp/ui/shared/style.dart';
import 'package:flutter/material.dart';

import '../../core/services/respository.dart';
import '../../locator.dart';
import '../shared/static_lists.dart';
import '../widgets/appbars.dart';
import '../widgets/misc.dart';
import 'package:dash_chat/dash_chat.dart';

class UserChat extends StatefulWidget {
  final String category;
  final Users currentUser;
  const UserChat({Key? key, required this.category, required this.currentUser})
      : super(key: key);

  @override
  State<UserChat> createState() => _UserChatState();
}

class _UserChatState extends State<UserChat> {
  final TextEditingController chatController = TextEditingController();
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();
  final Respository _respository = locator<Respository>();
  late ChatUser user;

  String chatRoomId = '';
  void onSend(ChatMessage message) async {
    chatController.clear();
    message.id = widget.category;

    String chatUserName = "${message.user.firstName} ${message.user.lastName}";

    Map<String, dynamic> completeMessage = {
      'chatUserName': chatUserName,
      'chatUserId': message.user.uid,
      'isRead': false,
      ...message.toJson()
    };

    _respository.addMessage(chatRoomId, completeMessage);
  }

  @override
  void initState() {
    user = ChatUser(
      name: widget.currentUser.userType,
      firstName: widget.currentUser.firstName,
      uid: widget.currentUser.userId,
      lastName: widget.currentUser.lastName,
    );
    chatRoomId = getChatRoomId(widget.currentUser.userId, widget.category);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InfoAppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: kWhite,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.asset(
                  'assets/images/logos/ghs_logo.png',
                  scale: 3,
                ),
              ),
            ),
            UiSpacing.horizontalSpacingTiny(),
            Text(
              programs[widget.category]!,
              style: Theme.of(context).textTheme.headline5,
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _respository.getMessages(chatRoomId),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              );
            } else {
              List<DocumentSnapshot> items = snapshot.data!.docs;
              List<ChatMessage> messages = items
                  .map((message) => ChatMessage.fromJson(message.data() as Map))
                  .toList();
// set "user has read message" to true
              for (var massageDoc in items) {
                if (massageDoc['user']['uid'] != widget.currentUser.userId) {
                  massageDoc.reference
                      .update(<String, dynamic>{'readByUser': true});
                }
              }
              return DashChat(
                onLoadEarlier: () {},
                shouldShowLoadEarlier: false,
                dateFormat: DateFormat.yMEd(),
                timeFormat: DateFormat('HH:mm'),
                messages: [...messages],
                onSend: onSend,
                user: user,
                key: _chatViewKey,
                textController: chatController,
                inputContainerStyle: const BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                inputToolbarPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                inputDecoration: InputDecoration(
                    hintText: '      Type message here',
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: kWhite)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: transGrey, width: 0),
                    ),
                    contentPadding: const EdgeInsets.all(8),
                    filled: true,
                    fillColor: transGrey),
                messageContainerDecoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: transGrey),
                ),
                inputTextStyle: Theme.of(context)
                    .textTheme
                    .headline3
                    ?.copyWith(fontSize: 13),
                sendButtonBuilder: (onSend) => GestureDetector(
                  onTap: () => onSend(),
                  child: const CircleAvatar(
                    backgroundColor: secondary1,
                    child: Icon(
                      Icons.send,
                      color: kWhite,
                    ),
                  ),
                ),
                textBeforeImage: false,
              );
            }
          }),
    );
  }
}
