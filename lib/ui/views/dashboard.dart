import 'package:fhmapp/core/model/post_model.dart';
import 'package:fhmapp/ui/shared/spacing.dart';
import 'package:fhmapp/ui/shared/style.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../core/services/respository.dart';
import '../../locator.dart';
import '../shared/static_lists.dart';
import '../viewmodels/profile_view_model.dart';
import '../widgets/appbars.dart';
import '../widgets/misc.dart';
import '../widgets/poster.dart';
import 'create_post.dart';

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
  final Respository _respository = locator<Respository>();

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
                  trailing: ViewModelBuilder<ProfileViewModel>.reactive(
                      viewModelBuilder: () => ProfileViewModel(),
                      onModelReady: (model) => model.getUserInfo(),
                      builder: (context, model, child) {
                        if (model.isBusy) {
                          return const SizedBox();
                        }
                        return (model.user.fhmappAdminFor != null &&
                                model.user.fhmappAdminFor!.isNotEmpty)
                            ? newPostCaller(
                                context,
                                model.user.fhmappAdminFor,
                                CreatePost(
                                    fhmappAdminFor: model.user.fhmappAdminFor))
                            : const SizedBox();
                      }),
                ),
                AllPosts(
                    respository: _respository,
                    topicFilters: _topicFilters,
                    filter: _filter)
                //   },
                // )
                //),
              ]),
              _focus.hasFocus ? tagFilter(context) : const SizedBox(),
            ],
          ),
        ),
      ),
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

class AllPosts extends StatelessWidget {
  const AllPosts({
    Key? key,
    required Respository respository,
    required List<String> topicFilters,
    required String? filter,
  })  : _respository = respository,
        _topicFilters = topicFilters,
        _filter = filter,
        super(key: key);

  final Respository _respository;
  final List<String> _topicFilters;
  final String? _filter;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Post>>(
        stream: _respository.getPosts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return SliverToBoxAdapter(
                child: Center(child: Text('Error: ${snapshot.error}')));
          }
          if (!snapshot.hasData) {
            return const SliverToBoxAdapter(
                child: Center(child: Text('Loading...')));
          }
          List<Post> posts = snapshot.data!;
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if ((_topicFilters.contains(posts[index].category) ||
                        _topicFilters.isEmpty) &&
                    (_filter == null ||
                        posts[index]
                            .content!
                            .toLowerCase()
                            .contains(_filter!.toLowerCase()) ||
                        posts[index]
                            .category
                            .toLowerCase()
                            .contains(_filter!.toLowerCase()))) {
                  return Poster(post: posts[index]);
                }
                return const SizedBox();
              },
              childCount: posts.length,
            ),
          );
        });
  }
}
