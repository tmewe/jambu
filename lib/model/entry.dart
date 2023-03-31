// ignore_for_file: sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Entry extends Equatable {
  const Entry({
    required this.userId,
    required this.reason,
  });

  final String userId;
  final String? reason;

  factory Entry.fromMap(Map<String, dynamic> map) {
    return Entry(
      userId: map['userId'] as String,
      reason: map['reason'] != null ? map['reason'] as String : null,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      if (reason != null) 'reason': reason,
    };
  }

  @override
  List<Object> get props => [userId];
}
