import 'package:fhmapp/ui/shared/static_lists.dart';
import 'package:flutter/material.dart';

import '../shared/style.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          color: transGrey,
          width: 50,
          height: 5,
        ),
        ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 20),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => const SizedBox(height: 30),
          itemCount: 5,
          itemBuilder: (context, index) => Center(
            child: Text(
              drawerItems.keys.toList()[index],
              style:
                  Theme.of(context).textTheme.headline5?.copyWith(fontSize: 15),
            ),
          ),
        )
      ],
    );
  }
}
