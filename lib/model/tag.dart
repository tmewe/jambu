// ignore_for_file: sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Tag extends Equatable {
  const Tag({
    required this.name,
    required this.userIds,
  });

  final String name;
  final List<String> userIds;

  @override
  List<Object> get props => [name, userIds];

  @override
  String toString() => name;

  Tag copyWith({
    String? name,
    List<String>? userIds,
  }) {
    return Tag(
      name: name ?? this.name,
      userIds: userIds ?? this.userIds,
    );
  }

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(
      name: map['name'] as String,
      userIds: List.from(map['userIds'] as Iterable),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'userIds': userIds,
    };
  }
}
