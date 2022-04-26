import 'package:flutter/material.dart';

import '../shared/static_lists.dart';
import '../widgets/appbars.dart';
import '../widgets/misc.dart';
import '../widgets/program_tile.dart';
import 'resources.dart';

class ResourcesCategory extends StatelessWidget {
  const ResourcesCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: scrollPhysics,
      slivers: [
        const SearchAppBar(),
        // SliverPadding(
        //   padding: const EdgeInsets.symmetric(horizontal: 30),
        //   sliver:
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ProgramTile(
                    index,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => Resources(
                            categoryKey: programs.keys.toList()[index],
                            categoryValue: programs.values.toList()[index]),
                      ),
                    ),
                  ));
            },
            childCount: 4,
          ),
        ),
        //),
      ],
    );
  }
}
