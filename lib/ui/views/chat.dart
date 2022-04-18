import 'package:fhmapp/ui/shared/spacing.dart';
import 'package:fhmapp/ui/shared/style.dart';
import 'package:flutter/material.dart';

import '../shared/static_lists.dart';
import '../widgets/appbars.dart';
import '../widgets/misc.dart';
import 'package:dash_chat/dash_chat.dart';

class Chat extends StatefulWidget {
  final String category;
  const Chat({Key? key, required this.category}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(physics: scrollPhysics, slivers: [
            InfoAppBar(
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
            //  SliverToBoxAdapter(
            //       child:)
          ]),
          DashChat(
            messages: const [],
            onSend: (chatMessage) {},
            user: ChatUser(),
            inputContainerStyle: const BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            inputToolbarPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
            inputDecoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: transGrey)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: transGrey, width: 0),
                ),
                // border: OutlineInputBorder(
                //     gapPadding: 0,
                //     borderSide: BorderSide(color: transGrey, width: 0),
                //     borderRadius: BorderRadius.circular(30)),
                contentPadding: const EdgeInsets.all(8),
                filled: true,
                fillColor: transGrey),
            messageContainerDecoration: BoxDecoration(
              border: Border.all(color: transGrey),
              // color: primaryColor,
            ),
            sendButtonBuilder: (onSend) => const CircleAvatar(
              backgroundColor: secondary1,
              child: Icon(
                Icons.send,
                color: kWhite,
              ),
            ),
            textBeforeImage: false,
          )
        ],
      ),
    );
  }
}
