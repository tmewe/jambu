class CalendarUser {
  CalendarUser({
    required this.id,
    required this.name,
    this.image,
    this.jobTitle,
    this.isFavorite = false,
    this.tags = const [],
  });

  final String id;
  final String name;
  final String? image;
  final String? jobTitle;
  final bool isFavorite;
  final List<String> tags;
}
