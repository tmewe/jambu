// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:jambu/calendar/core/smart_merge/presence.dart';
import 'package:jambu/extension/datetime_extension.dart';
import 'package:jambu/model/model.dart';

class MergePresencesAttendances {
  MergePresencesAttendances({
    required this.presences,
    required this.attendances,
    required this.currentUser,
  });

  final List<Presence> presences;
  final List<Attendance> attendances;
  final User currentUser;

  List<Attendance> call() {
    var resultAttendances = [...attendances];
    for (final presence in presences) {
      final attendanceAtDate = resultAttendances.firstWhereOrNull(
        (e) => e.date.isSameDay(presence.date),
      );
      // The user is in the office at this date
      if (presence.isPresent) {
        resultAttendances = _updateAttendancesIfPresent(
          attendanceAtDate: attendanceAtDate,
          presence: presence,
          attendances: resultAttendances,
        );
      }
      // The user is not in the office at this date
      else {
        resultAttendances = _updateAttendancesIfAbsent(
          attendanceAtDate: attendanceAtDate,
          presence: presence,
          attendances: resultAttendances,
        );
      }
    }
    return resultAttendances;
  }

  List<Attendance> _updateAttendancesIfPresent({
    required Attendance? attendanceAtDate,
    required Presence presence,
    required List<Attendance> attendances,
  }) {
    final attendaceExists = attendanceAtDate != null;
    final resultAttendances = [...attendances];

    if (attendaceExists) {
      resultAttendances.remove(attendanceAtDate);

      final updatedPresent = {
        ...attendanceAtDate.present,
        Entry(userId: currentUser.id, reason: presence.reason),
      }.toList();
      final updatedAbsent = {
        ...attendanceAtDate.absent.where((e) => e.userId != currentUser.id)
      }.toList();

      final updatedAttendance = attendanceAtDate.copyWith(
        present: updatedPresent,
        absent: updatedAbsent,
      );
      resultAttendances.add(updatedAttendance);
    }
    // Create new attendance
    else {
      resultAttendances.add(
        Attendance(
          date: presence.date,
          present: [Entry(userId: currentUser.id, reason: presence.reason)],
        ),
      );
    }
    return resultAttendances;
  }

  List<Attendance> _updateAttendancesIfAbsent({
    required Attendance? attendanceAtDate,
    required Presence presence,
    required List<Attendance> attendances,
  }) {
    final attendaceExists = attendanceAtDate != null;
    final resultAttendances = [...attendances];

    if (attendaceExists) {
      resultAttendances.remove(attendanceAtDate);

      final updatedPresent = {
        ...attendanceAtDate.present.where((e) => e.userId != currentUser.id)
      }.toList();
      final updatedAbsent = {
        ...attendanceAtDate.absent,
        if (presence.reason != null) // Only add if there is a reason
          Entry(
            userId: currentUser.id,
            reason: presence.reason,
          ),
      }.toList();

      final updatedAttendance = attendanceAtDate.copyWith(
        present: updatedPresent,
        absent: updatedAbsent,
      );
      // Only add the attendance if it contains users
      if (updatedAttendance.present.isNotEmpty ||
          updatedAttendance.absent.isNotEmpty) {
        resultAttendances.add(updatedAttendance);
      }
    } else if (!attendaceExists && presence.reason != null) {
      resultAttendances.add(
        Attendance(
          date: presence.date,
          absent: [Entry(userId: currentUser.id, reason: presence.reason)],
        ),
      );
    }
    return resultAttendances;
  }
}
