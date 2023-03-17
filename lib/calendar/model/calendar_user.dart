// ignore_for_file: public_member_api_docs, sort_constructors_first
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
}
