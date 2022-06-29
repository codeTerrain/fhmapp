import 'package:flutter/material.dart';

import '../../core/services/utilities.dart';
import '../shared/static_lists.dart';
import '../shared/style.dart';
import 'misc.dart';

class ProgramTile extends StatelessWidget {
  final int index;
  final String id;
  final GestureTapCallback? onTap;
  final Widget? trailing;
  final String text;
  const ProgramTile(this.index,
      {Key? key,
      required this.id,
      required this.text,
      this.onTap,
      this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        shape: roundedListTileBorder,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        tileColor: kWhite,
        leading: Image.asset(
          'assets/images/programs/$id.png',
          scale: 2.5,
        ),
        horizontalTitleGap: 10,
        title: Text(
          text,
          style: Theme.of(context).textTheme.headline3,
        ),
        trailing: trailing,
        onTap: onTap);
  }
}

class ProfileTile extends StatelessWidget {
  final int index;

  final Widget? trailing;
  ProfileTile(this.index, {Key? key, this.trailing}) : super(key: key);

  final List tileNames = ['personal', 'security', 'privacy', 'logout'];
  final List profileItems = [
    'Personal Info',
    'Security',
    'Privacy & Policy',
    'Logout'
  ];

  @override
  Widget build(BuildContext context) {
    return ListTile(
        shape: roundedListTileBorder,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        tileColor: kWhite,
        leading: Image.asset(
          'assets/images/profile/${tileNames[index]}.png',
          // color: primaryColor,
          // scale: 8,
        ),
        horizontalTitleGap: 10,
        title: Hero(
          tag: tileNames[index],
          child: Text(
            profileItems[index],
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: primaryColor,
        ),
        onTap: () => tileNames[index] == 'logout'
            ? Utilities.confirmLogout(context)
            : Navigator.pushNamed(context, '/${tileNames[index]}'));
  }
}
