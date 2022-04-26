import 'package:fhmapp/core/model/post_model.dart';
import 'package:fhmapp/ui/shared/spacing.dart';
import 'package:fhmapp/ui/shared/style.dart';
import 'package:flutter/material.dart';
import '../widgets/appbars.dart';
import '../widgets/misc.dart';
import '../widgets/poster.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomScrollView(physics: scrollPhysics, slivers: [
          const SearchAppBar(),
          // SliverPadding(
          //   padding: const EdgeInsets.symmetric(horizontal: 30),
          //sliver:
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Poster(post: dummyPosts[index]),
              childCount: 3,
            ),
          ),
          //),
        ]),
        //  const Positioned(top: 65, child: TagChips()),
      ],
    );
  }
}

class ProgramChips {
  String label;
  Color color;
  bool isSelected;
  ProgramChips(this.label, this.color, this.isSelected);
}

class TagChips extends StatefulWidget {
  const TagChips({Key? key}) : super(key: key);

  @override
  State<TagChips> createState() => _TagChipsState();
}

class _TagChipsState extends State<TagChips> {
  bool selected = false;

  final List<ProgramChips> _chipsList = [
    ProgramChips("Family Planning", kWhite, false),
    ProgramChips("Adolescent Health", kWhite, false),
    ProgramChips("Nutrition", kWhite, false),
    ProgramChips("Maternal and Child Health", kWhite, false),
  ];
  // final List<ProgramChips> _chipsList = programs.entries.map((e) {
  //   return ProgramChips(e, color, false);
  // }).toList() as List<ProgramChips>;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          width: UiSpacing.screenSize(context).width,
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 20),
                  child: Text(
                    'Filter Topic by:',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(color: grey),
                  ),
                ),
                Wrap(
                  spacing: 8,
                  direction: Axis.horizontal,
                  children: programChips(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> programChips() {
    List<Widget> chips = [];
    for (int i = 0; i < _chipsList.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.only(left: 10, right: 5),
        child: FilterChip(
          label: Text(
            _chipsList[i].label,
          ),
          selectedColor: primaryColor,
          showCheckmark: false,
          labelStyle:
              TextStyle(color: _chipsList[i].isSelected ? kWhite : kBlack),
          backgroundColor: _chipsList[i].color,
          selected: _chipsList[i].isSelected,
          onSelected: (bool value) {
            setState(() {
              _chipsList[i].isSelected = value;
            });
          },
        ),
      );
      chips.add(item);
    }
    return chips;
  }
}
