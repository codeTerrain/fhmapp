import 'package:flutter/material.dart';

import '../shared/static_lists.dart';
import '../shared/style.dart';
import 'misc.dart';

class ProgramTile extends StatelessWidget {
  final int index;
  final GestureTapCallback? onTap;
  final Widget? trailing;
  const ProgramTile(this.index, {Key? key, this.onTap, this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        shape: roundedListTileBorder,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        tileColor: kWhite,
        leading: Image.asset(
          'assets/images/logos/ghs_logo.png',
          scale: 3,
        ),
        title: Text(
          programs.values.toList()[index],
          style: Theme.of(context).textTheme.bodyText1?.copyWith(color: grey),
        ),
        trailing: trailing,
        onTap: onTap);
  }
}
