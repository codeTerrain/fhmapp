import 'package:flutter/material.dart';

import '../shared/static_lists.dart';
import '../widgets/appbars.dart';
import '../widgets/misc.dart';
import '../widgets/tiles.dart';

class MedicalScreening extends StatelessWidget {
  const MedicalScreening({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: scrollPhysics,
        slivers: [
          SliverInfoAppBar(
            title: Text(
              'Medical Screening',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),

          SliverPadding(
            padding: mainPadding,
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ProgramTile(index,
                          text: medicalScreening.values.toList()[index],
                          onTap: () {}));
                },
                childCount: 3,
              ),
            ),
          ),
          //),
        ],
      ),
    );
  }
}
