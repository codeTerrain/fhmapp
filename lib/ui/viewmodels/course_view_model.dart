import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked/stacked.dart';

import '../../core/model/course_model.dart';
import '../../core/services/respository.dart';
import '../../locator.dart';

class CourseViewModel extends FutureViewModel {
  final Respository _respository = locator<Respository>();
  final List<Course> _courses = [];
  List<Course> get courses => _courses;

  Future getAllCourses() async {
    setBusy(true);
    var allCourses = await _respository.getCourses();
    if (allCourses is QuerySnapshot) {
      List<DocumentSnapshot> coursesDocs = allCourses.docs;
      for (var doc in coursesDocs) {
        Map<String, Object> data = {
          'courseDocId': doc.id,
          'id': doc['id'],
          'name': doc['name'],
          'description': doc['description'],
          'url': doc['url'],
          'category': doc['category'],
          'duration': doc['duration'],
          'userTaps': doc['userTaps'],
        };
        var downloadedResource =
            _courses.where((course) => course.id == doc['id']);

        if (downloadedResource.isEmpty) {
          _courses.add(Course.fromAPI(data));
        }
        notifyListeners();
      }
    } else {
      print('error retrieving courses');
    }
    setBusy(false);
  }

  @override
  Future futureToRun() => getAllCourses();
}
