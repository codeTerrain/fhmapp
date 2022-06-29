import 'package:flutter/material.dart';

import '../shared/static_lists.dart';
import '../widgets/appbars.dart';
import '../widgets/misc.dart';
import '../widgets/tiles.dart';

class SchoolClinic extends StatelessWidget {
  const SchoolClinic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: scrollPhysics,
        slivers: [
          SliverInfoAppBar(
            title: Text(
              'School Clinic',
              style: Theme.of(context).textTheme.headline5,
            ),
            //  trailing: drawerCaller(context),
          ),

          SliverPadding(
            padding: mainPadding,
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ProgramTile(
                        index, id: programs.keys.toList()[index],
                        text: schoolClinic.values.toList()[index],
                        onTap: () => null,
                        // Navigator.push(
                        //       context,
                        //       MaterialPageRoute<void>(
                        //         builder: (BuildContext context) => MyHomePage(
                        //           title: 'Image View',
                        //         ),
                        //       ),
                        //     )
                      ));
                },
                childCount: 4,
              ),
            ),
          ),
          //),
        ],
      ),
    );
  }
}
