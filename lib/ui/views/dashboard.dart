import 'package:fhmapp/core/model/post_model.dart';
import 'package:fhmapp/ui/shared/spacing.dart';
import 'package:fhmapp/ui/shared/style.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../shared/static_lists.dart';
import '../viewmodels/search_view.dart';
import '../widgets/appbars.dart';
import '../widgets/misc.dart';
import '../widgets/poster.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? _filter;

  bool foc = false;
  final TextEditingController _searchController = TextEditingController();
  late List<String> _topicFilters;

  @override
  void initState() {
    _topicFilters = [];
    _searchController.addListener(() {
      setState(() {
        _filter = _searchController.text;
      });
    });
    super.initState();
  }

  final FocusNode _focus = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _focus.dispose();
  }

  onFocusChange(bool focus) {
    setState(() {
      foc = focus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchViewModel>.reactive(
      viewModelBuilder: () => SearchViewModel(),
      builder: (context, model, child) {
        return FocusScope(
          child: Focus(
            focusNode: _focus,
            onFocusChange: onFocusChange,
            child: Listener(
              onPointerMove: (moveEvent) {
                if (foc) {
                  foc = false;
                  _focus.unfocus();
                }
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomScrollView(physics: scrollPhysics, slivers: [
                    SearchAppBar(
                      searchController: _searchController,
                      filter: _filter,
                      trailing: newPostCaller(context),
                    ),

                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if ((_topicFilters
                                      .contains(dummyPosts[index].category) ||
                                  _topicFilters.isEmpty) &&
                              (_filter == null ||
                                  dummyPosts[index]
                                      .content!
                                      .toLowerCase()
                                      .contains(_filter!.toLowerCase()) ||
                                  dummyPosts[index]
                                      .category
                                      .toLowerCase()
                                      .contains(_filter!.toLowerCase()))) {
                            return Poster(post: dummyPosts[index]);
                          }
                          return const SizedBox();
                        },
                        childCount: 3,
                      ),
                    ),
                    //),
                  ]),
                  _focus.hasFocus ? tagFilter(context) : const SizedBox(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Positioned tagFilter(BuildContext context) {
    return Positioned(
      top: 65,
      child: SafeArea(
        child: Container(
          decoration: boxDecoration,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          width: UiSpacing.screenSize(context).width / 1.07,
          child: Wrap(
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
    );
  }

  List<Widget> programChips() {
    List<Widget> chips = [];
    for (int i = 0; i < programList.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.only(left: 10, right: 5),
        child: FilterChip(
          label: Text(
            programList[i].name,
          ),
          selectedColor: primaryColor,
          showCheckmark: false,
          labelStyle: TextStyle(
              color: _topicFilters.contains(programList[i].name)
                  ? kWhite
                  : kBlack),
          backgroundColor: programList[i].isSelected ? primaryColor : kWhite,
          selected: _topicFilters.contains(programList[i].name),
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                _topicFilters.add(programList[i].name);
              } else {
                _topicFilters.removeWhere((String name) {
                  return name == programList[i].name;
                });
              }
            });
          },
        ),
      );
      chips.add(item);
    }
    return chips;
  }
}
