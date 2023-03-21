import 'package:jambu/calendar/core/smart_merge/event_to_presences_mapping.dart';
import 'package:jambu/calendar/core/smart_merge/filter_presences.dart';
import 'package:jambu/calendar/core/smart_merge/merge_manual_absences.dart';
import 'package:jambu/calendar/core/smart_merge/merge_presences_attendances.dart';
import 'package:jambu/calendar/core/smart_merge/merge_regular_attendances.dart';
import 'package:jambu/extension/extension.dart';
import 'package:jambu/model/model.dart';
import 'package:jambu/ms_graph/model/model.dart';

class SmartMerge {
  SmartMerge({
    required User currentUser,
    required List<MSEvent> msEvents,
    required List<Attendance> firestoreAttendances,
  })  : _currentUser = currentUser,
        _msEvents = msEvents,
        _fsAttendances = firestoreAttendances;

  final User _currentUser;
  final List<MSEvent> _msEvents;
  final List<Attendance> _fsAttendances;

  List<Attendance> call() {
    if (_msEvents.isEmpty) {
      return _fsAttendances;
    }

    var presences = _msEvents
        .map((event) => EventToPresencesMapping(event: event)())
        .expand((p) => p)
        .toList();

    presences = MergeRegularAttendances(
      date: DateTime.now().midnight,
      regularAttendances: _currentUser.regularAttendances,
      presences: presences,
    )();

    presences = MergeManualAbsences(
      presences: presences,
      absences: _currentUser.manualAbsences,
    )();

    presences = FilterPresences(presences: presences)();

    final attendances = MergePresencesAttendances(
      presences: presences,
      attendances: _fsAttendances,
      currentUser: _currentUser,
    )();

    return attendances;
  }
}
