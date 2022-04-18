import 'package:fhmapp/ui/shared/spacing.dart';
import 'package:fhmapp/ui/widgets/search.dart';
import 'package:flutter/material.dart';

import '../shared/style.dart';
import 'drawer.dart';

class SearchAppBar extends StatelessWidget {
  const SearchAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var boxDecoration =
        BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10));
    return SliverAppBar(
      backgroundColor: scaffoldColor,
      automaticallyImplyLeading: false,
      centerTitle: true,
      leadingWidth: 0,
      elevation: 0,
      pinned: true,
      toolbarHeight: 80,
      titleSpacing: 0,
      title: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            child: IconButton(
              onPressed: () => showModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(25))),
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => const CustomDrawer()),
              icon: Image.asset('assets/images/general/drawerIcon.png'),
              color: primaryColor,
            ),
            decoration: boxDecoration,
          ),
          UiSpacing.horizontalSpacingTiny(),
          Expanded(child: search(context, hintText: 'Search')),
        ],
      ),
    );
  }
}

class InfoAppBar extends StatelessWidget {
  final Widget? title;
  final Widget? subTitle;
  const InfoAppBar({Key? key, required this.title, this.subTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var boxDecoration =
        BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10));
    return SliverAppBar(
      backgroundColor: scaffoldColor,
      pinned: true,
      automaticallyImplyLeading: false,
      centerTitle: true,
      leadingWidth: 0,
      elevation: 0,
      toolbarHeight: 80,
      titleSpacing: 30,
      title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Image.asset('assets/images/general/arrowBack.png'),
                color: primaryColor,
              ),
              decoration: boxDecoration,
            ),
            UiSpacing.horizontalSpacingTiny(),
            Expanded(
                child: ListTile(
                    dense: true,
                    minVerticalPadding: 1,
                    title: title,
                    subtitle: subTitle)),
          ],
        ),
      ]),
    );
  }
}
