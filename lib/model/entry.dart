// ignore_for_file: sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Entry extends Equatable {
  const Entry({
    required this.userId,
    this.reason,
    this.isHoliday,
  });

  final String userId;
  final String? reason;
  final bool? isHoliday;

  factory Entry.fromMap(Map<String, dynamic> map) {
    return Entry(
      userId: map['userId'] as String,
      reason: map['reason'] != null ? map['reason'] as String : null,
      isHoliday: map['isHoliday'] != null ? map['isHoliday'] as bool : null,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      if (reason != null) 'reason': reason,
      if (isHoliday != null) 'isHoliday': isHoliday,
    };
  }

  @override
  List<Object> get props => [userId];
}
