import 'package:flutter/material.dart';

import '../shared/static_lists.dart';
import '../widgets/appbars.dart';
import '../widgets/misc.dart';
import '../widgets/tiles.dart';
import 'resources.dart';

class ResourcesCategory extends StatefulWidget {
  const ResourcesCategory({Key? key}) : super(key: key);

  @override
  State<ResourcesCategory> createState() => _ResourcesCategoryState();
}

class _ResourcesCategoryState extends State<ResourcesCategory> {
  String? _filter;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _filter = _searchController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: scrollPhysics,
      slivers: [
        SearchAppBar(searchController: _searchController, filter: _filter),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (_filter == null ||
                  programs.keys
                      .toList()[index]
                      .toLowerCase()
                      .contains(_filter!.toLowerCase()) ||
                  programs.values
                      .toList()[index]
                      .toLowerCase()
                      .contains(_filter!.toLowerCase())) {
                return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ProgramTile(
                      index,
                      text: programs.values.toList()[index],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => Resources(
                              categoryKey: programs.keys.toList()[index],
                              categoryValue: programs.values.toList()[index]),
                        ),
                      ),
                    ));
              }
              return const SizedBox();
            },
            childCount: 4,
          ),
        ),
        //),
      ],
    );
  }
}
