// import 'dart:async';

// import 'package:stacked/stacked.dart';



// class ResourceViewModel extends StreamViewModel<int> {
//   String get title => 'This is the time since epoch in seconds \n $data';

//   Stream<List<T>> combineListStreams<T>(List<Stream<List<T>>> streams) {
//   var controller = StreamController<List<T>>();
//   Set activeStreams = {};
//   Map<Stream<List<T>>, List<T>> lastValues = {};

//   for (var stream in streams) {
//     activeStreams.add(stream);
//     stream.listen((val) {
//       lastValues[stream] = val;
//       List<T> out = [];
//       for (var list in lastValues.values) {
//         out.addAll(list);
//       }
//       controller.add(out);
//     }, onDone: () {
//       activeStreams.remove(stream);
//       if (activeStreams.isEmpty) {
//         controller.close();
//       }
//     });
//   }
//   return controller.stream;
// }

//   @override
//   Stream<int> get stream => locator<EpochService>().epochUpdatesNumbers();
// }
