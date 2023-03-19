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

    final presenceDays =
        _msEvents.map(_eventToPresences).expand((p) => p).toList();

    final uniquePresenceDays = _removeDuplicates(presenceDays);

    final attendances = _merge(
      presenceDays: uniquePresenceDays,
      attendances: _fsAttendances,
    );

    return attendances;
  }

  List<_Presence> _removeDuplicates(List<_Presence> presenceDays) {
    final uniqueDays = <_Presence>[];
    for (final presence in presenceDays) {
      final index = uniqueDays.indexWhere((e) {
        return e.date.isSameDay(presence.date);
      });

      if (index == -1) {
        uniqueDays.add(presence);
      } else {
        final existingStatus = uniqueDays[index];
        if (existingStatus.isPresent == true && presence.isPresent == false) {
          uniqueDays
            ..removeAt(index)
            ..add(presence);
        }
      }
    }
    return uniqueDays;
  }

  List<_Presence> _eventToPresences(MSEvent event) {
    // Get the duration of the event (could be multiple days)
    var eventDuration =
        event.end.date.difference(event.start.date).abs().inDays;
    
    // One day is the minimum
    if (eventDuration == 0) {
      eventDuration = 1;
    }
    final presences = <_Presence>[];
    for (var i = 0; i < eventDuration; i++) {
      final date = event.start.date.add(Duration(days: i));
      if (event.isWholeDayOOF) {
        presences.add(_Presence(date: date, isPresent: false));
      } else if (event.isPresenceWithMultipleAttendees) {
        presences.add(_Presence(date: date, isPresent: true));
      }
    }
    return presences;
  }

  List<Attendance> _merge({
    required List<_Presence> presenceDays,
    required List<Attendance> attendances,
  }) {
    final resultAttendances = [...attendances];
    for (final presence in presenceDays) {
      final index = resultAttendances.indexWhere((e) {
        return e.date.isSameDay(presence.date);
      });
      final attendaceExists = index != -1;
      // The user is in the office at this date
      if (presence.isPresent) {
        // Add user to existing attendance
        if (attendaceExists) {
          final attendance = resultAttendances.removeAt(index);
          final updatedAttendance = attendance.copyWith(
            userIds: [...attendance.userIds, _currentUser.id],
          );
          resultAttendances.add(updatedAttendance);
        }
        // Create new attendance
        else {
          resultAttendances.add(
            Attendance(date: presence.date, userIds: [_currentUser.id]),
          );
        }
      }
      // The user is not in the office at this date
      else if (attendaceExists && !presence.isPresent) {
        final attendance = resultAttendances.removeAt(index);
        final filteredUsers = attendance.userIds.where((e) {
          return e != _currentUser.id;
        }).toList();
        // Only add the attendance is it contains users
        if (filteredUsers.isNotEmpty) {
          resultAttendances.add(
            attendance.copyWith(userIds: filteredUsers),
          );
        }
      }
    }
    return resultAttendances;
  }
}

class _Presence {
  _Presence({
    required this.date,
    required this.isPresent,
  });

  final DateTime date;
  final bool isPresent;
}
