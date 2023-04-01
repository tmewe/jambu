import 'package:equatable/equatable.dart';

class CalendarUser extends Equatable {
  const CalendarUser({
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

  @override
  List<Object> get props {
    return [id, name, isFavorite, tags];
  }

  CalendarUser copyWith({
    String? id,
    String? name,
    String? image,
    String? jobTitle,
    bool? isFavorite,
    List<String>? tags,
  }) {
    return CalendarUser(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      jobTitle: jobTitle ?? this.jobTitle,
      isFavorite: isFavorite ?? this.isFavorite,
      tags: tags ?? this.tags,
    );
  }
}
