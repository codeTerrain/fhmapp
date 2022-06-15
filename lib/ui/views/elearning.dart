import 'package:fhmapp/ui/shared/spacing.dart';
import 'package:fhmapp/ui/shared/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

import '../../core/model/course_model.dart';
import '../viewmodels/course_view_model.dart';
import '../widgets/appbars.dart';
import '../widgets/misc.dart';
import 'course_view.dart';

class ELearning extends StatefulWidget {
  const ELearning({Key? key}) : super(key: key);

  @override
  State<ELearning> createState() => _ELearningState();
}

class _ELearningState extends State<ELearning> {
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
        ViewModelBuilder<CourseViewModel>.reactive(
            viewModelBuilder: () => CourseViewModel(),
            onModelReady: (model) => model.getAllCourses(),
            builder: (context, model, child) {
              List<Course> courses = model.courses;
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (_filter == null ||
                        courses[index]
                            .name
                            .toLowerCase()
                            .contains(_filter!.toLowerCase()) ||
                        courses[index]
                            .category
                            .toLowerCase()
                            .contains(_filter!.toLowerCase())) {
                      return CourseCard(course: courses[index]);
                    }
                    return const SizedBox();
                  },
                  childCount: courses.length,
                ),
              );
            }),
      ],
    );
  }
}

class CourseCard extends StatelessWidget {
  final Course course;
  const CourseCard({
    required this.course,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      elevation: 0,
      color: kWhite,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SizedBox(
          width: UiSpacing.screenSize(context).width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: kBlack,
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                        image: AssetImage(
                          'assets/images/dashboard/dummyFamily.png',
                        ),
                        fit: BoxFit.cover)),
                height: 120,
                width: 130,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    UiSpacing.horizontalSpacingTiny(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          course.name,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        UiSpacing.verticalSpacingTiny(),
                        programmeTag(context,
                            margin: 0,
                            text: course.category,
                            style: Theme.of(context).textTheme.headline4),
                        UiSpacing.verticalSpacingTiny(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: SizedBox(
                            width: 150,
                            child: Text(
                              course.description ?? 'N/A',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(color: grey),
                            ),
                          ),
                        ),
                        Text(
                          'Uploaded: ${DateFormat('yMMMd').format(course.duration)}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: grey, fontSize: 13),
                        ),
                      ],
                    ),
                    const Spacer(),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: primaryColor,
                      child: IconButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                CourseView(url: course.url),
                          ),
                        ),
                        icon: const Icon(
                          Icons.video_library,
                          color: kWhite,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
