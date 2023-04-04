part of 'calendar_bloc.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object?> get props => [];
}

class CalendarRequested extends CalendarEvent {}

class CalendarAttendanceUpdate extends CalendarEvent {
  const CalendarAttendanceUpdate({
    required this.date,
    required this.isAttending,
    this.reason,
  });

  final DateTime date;
  final bool isAttending;
  final String? reason;

  @override
  List<Object?> get props => [date, isAttending];
}

class CalendarSearchTextUpdate extends CalendarEvent {
  const CalendarSearchTextUpdate({this.searchText = ''});

  final String searchText;
}

class CalendarTagFilterUpdate extends CalendarEvent {
  const CalendarTagFilterUpdate({this.tags = const []});

  final List<String> tags;
}

class CalendarAddTag extends CalendarEvent {
  const CalendarAddTag({
    required this.tagName,
    required this.userId,
  });

  final String tagName;
  final String userId;
}

class CalendarRemoveTag extends CalendarEvent {
  const CalendarRemoveTag({
    required this.tagName,
    required this.userId,
  });

  final String tagName;
  final String userId;
}

class CalendarUpdateTagName extends CalendarEvent {
  const CalendarUpdateTagName({
    required this.tagName,
    required this.newTagName,
  });

  final String tagName;
  final String newTagName;
}

class CalenderUpdateFavorite extends CalendarEvent {
  const CalenderUpdateFavorite({
    required this.userId,
    required this.isFavorite,
  });

  final String userId;
  final bool isFavorite;
}
