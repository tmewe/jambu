import 'package:flutter/foundation.dart';
import 'package:jambu/backend/backend.dart';
import 'package:jambu/calendar/core/core.dart';
import 'package:jambu/constants.dart';
import 'package:jambu/holidays/repository/repository.dart';
import 'package:jambu/model/model.dart';
import 'package:jambu/repository/repository.dart';

class SmartSync {
  SmartSync({
    required User currentUser,
    required FirestoreRepository firestoreRepository,
    required MSGraphRepository msGraphRepository,
    required HolidaysRepository holidaysRepository,
  })  : _currentUser = currentUser,
        _firestoreRepository = firestoreRepository,
        _msGraphRepository = msGraphRepository,
        _holidaysRepository = holidaysRepository;

  final User _currentUser;
  final FirestoreRepository _firestoreRepository;
  final MSGraphRepository _msGraphRepository;
  final HolidaysRepository _holidaysRepository;

  Future<List<Attendance>> call() async {
    debugPrint('Start smart sync');
    final msEvents = await _msGraphRepository.fetchEventsStartingToday(
      // TODO(tim): Just for testing
      calendarId: kDebugMode ? Constants.testCalendarId : null,
    );
    final firestoreAttendances = await _firestoreRepository.getAttendances();

    final holidays =
        await _holidaysRepository.fetchNationwideHolidaysInNextFourWeeks();

    final updatedAttendances = SmartMerge(
      currentUser: _currentUser,
      msEvents: msEvents,
      firestoreAttendances: firestoreAttendances,
      holidays: holidays,
    )();

    await SmartUpload(
      currentUser: _currentUser,
      msEvents: msEvents,
      updatedAttendances: updatedAttendances,
      msGraphRepository: _msGraphRepository,
      firestoreRepository: _firestoreRepository,
    )();

    return updatedAttendances;
  }
}
