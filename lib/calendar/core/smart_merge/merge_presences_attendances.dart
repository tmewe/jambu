// ignore_for_file: public_member_api_docs, sort_constructors_first
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
    final resultAttendances = [...attendances];
    for (final presence in presences) {
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
            userIds: [...attendance.userIds, currentUser.id],
          );
          resultAttendances.add(updatedAttendance);
        }
        // Create new attendance
        else {
          resultAttendances.add(
            Attendance(date: presence.date, userIds: [currentUser.id]),
          );
        }
      }
      // The user is not in the office at this date
      else if (attendaceExists && !presence.isPresent) {
        final attendance = resultAttendances.removeAt(index);
        final filteredUsers = attendance.userIds.where((e) {
          return e != currentUser.id;
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
