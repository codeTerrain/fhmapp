import 'package:stacked/stacked.dart';

class SearchViewModel extends MultipleFutureViewModel {
  final List list = [];

  @override
  Map<String, Future Function()> get futuresMap => {};
}
