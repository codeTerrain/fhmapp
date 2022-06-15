import 'package:fhmapp/ui/shared/spacing.dart';
import 'package:fhmapp/ui/widgets/search.dart';
import 'package:flutter/material.dart';

import '../shared/style.dart';
import 'misc.dart';

class SearchAppBar extends StatelessWidget {
  final TextEditingController searchController;
  final String? filter;
  final Widget? trailing;
  const SearchAppBar(
      {required this.searchController, this.trailing, this.filter, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          drawerCaller(context),
          UiSpacing.horizontalSpacingTiny(),
          Expanded(
              child: search(context,
                  hintText: 'Search',
                  controller: searchController,
                  filter: filter)),
          trailing ?? const SizedBox()
        ],
      ),
    );
  }
}

class SearchAppBar1 extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final String? filter;
  final Widget? trailing;
  const SearchAppBar1(
      {required this.searchController, this.trailing, this.filter, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      centerTitle: true,
      leadingWidth: 0,
      elevation: 0,
      toolbarHeight: 80,
      titleSpacing: 0,
      title: Row(
        children: [
          drawerCaller(context),
          UiSpacing.horizontalSpacingTiny(),
          Expanded(
              child: search(context,
                  hintText: 'Search',
                  controller: searchController,
                  filter: filter)),
          trailing ?? const SizedBox()
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class SliverInfoAppBar extends StatelessWidget {
  final Widget? title;
  final Widget? subTitle;
  final Color? backgroundColor;
  final Widget? trailing;
  final PreferredSizeWidget? bottom;
  const SliverInfoAppBar(
      {Key? key,
      this.trailing,
      this.backgroundColor,
      required this.title,
      this.bottom,
      this.subTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var boxDecoration =
        BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10));
    return SliverAppBar(
      backgroundColor: backgroundColor ?? scaffoldColor,
      pinned: true,
      automaticallyImplyLeading: false,
      centerTitle: true,
      leadingWidth: 0,
      elevation: 0,
      toolbarHeight: bottom != null ? 120 : 80,
      titleSpacing: 15,
      bottom: bottom,
      title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
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
              subtitle: subTitle,
              trailing: trailing,
              contentPadding: const EdgeInsets.only(right: 0),
            )),
          ],
        ),
      ]),
    );
  }
}

class InfoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? subTitle;
  final Color? backgroundColor;
  final Widget? trailing;
  final PreferredSizeWidget? bottom;
  const InfoAppBar(
      {Key? key,
      this.bottom,
      this.trailing,
      this.backgroundColor,
      this.title,
      this.subTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var boxDecoration =
        BoxDecoration(color: kWhite, borderRadius: BorderRadius.circular(10));
    return AppBar(
      backgroundColor: backgroundColor ?? scaffoldColor,
      // pinned: true,
      automaticallyImplyLeading: false,
      centerTitle: true,
      leadingWidth: 0,
      elevation: 0,

      toolbarHeight: bottom != null ? 120 : 80,
      titleSpacing: 15,
      bottom: bottom,
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
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    minVerticalPadding: 1,
                    title: title,
                    subtitle: subTitle,
                    trailing: trailing)),
          ],
        ),
      ]),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(bottom == null ? 70 : 120);
}
