// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Presence extends Equatable {
  const Presence({
    required this.date,
    required this.isPresent,
    this.reason,
  });

  final DateTime date;
  final bool isPresent;
  final String? reason;

  @override
  List<Object> get props => [date, isPresent];

  @override
  bool get stringify => true;
}
