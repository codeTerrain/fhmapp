class Course {
  final String courseDocId;
  final String id;
  final String url;
  final String name;
  final String? description;
  final String category;
  final DateTime duration;
  final List userTaps;

  Course({
    required this.courseDocId,
    required this.id,
    required this.name,
    required this.description,
    required this.url,
    required this.category,
    required this.duration,
    required this.userTaps,
  });

  factory Course.fromAPI(Map data) => Course(
        courseDocId: data['courseDocId'],
        id: data['id'],
        name: data['name'],
        description: data['description'],
        url: data['url'],
        category: data['category'],
        duration: data['duration'].toDate(),
        userTaps: data['userTaps'],
      );
}
