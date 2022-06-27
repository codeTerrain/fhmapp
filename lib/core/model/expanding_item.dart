class ExpandingItem {
  final String title;
  final Map<String, String> content;
  bool isExpanded;

  ExpandingItem(
      {required this.title, required this.content, this.isExpanded = false});
}
