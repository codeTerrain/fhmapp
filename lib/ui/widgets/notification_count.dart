import 'package:flutter/material.dart';

import '../shared/style.dart';

class NotificationCount extends StatefulWidget {
  const NotificationCount({Key? key}) : super(key: key);

  @override
  State<NotificationCount> createState() => _NotificationCountState();
}

class _NotificationCountState extends State<NotificationCount> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 6),
      decoration: BoxDecoration(
          color: primaryColor, borderRadius: BorderRadius.circular(10)),
      child: Text(
        '2',
        style: Theme.of(context).textTheme.headline3?.copyWith(color: kWhite),
      ),
    );
  }
}
