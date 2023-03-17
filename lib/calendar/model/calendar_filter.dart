import 'package:equatable/equatable.dart';

class CalendarFilter extends Equatable {
  const CalendarFilter({
    this.search = '',
    this.tags = const [],
  });

  final String search;
  final List<String> tags;

  @override
  List<Object> get props => [search, tags];
}
