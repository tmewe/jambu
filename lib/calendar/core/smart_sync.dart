import 'package:flutter/foundation.dart';
import 'package:jambu/backend/backend.dart';
import 'package:jambu/calendar/core/core.dart';
import 'package:jambu/model/model.dart';
import 'package:jambu/repository/repository.dart';

class SmartSync {
  SmartSync({
    required User currentUser,
    required FirestoreRepository firestoreRepository,
    required MSGraphRepository msGraphRepository,
  })  : _currentUser = currentUser,
        _firestoreRepository = firestoreRepository,
        _msGraphRepository = msGraphRepository;

  final User _currentUser;
  final FirestoreRepository _firestoreRepository;
  final MSGraphRepository _msGraphRepository;

  Future<List<Attendance>> call() async {
    debugPrint('Start smart sync');
    final msEvents = await _msGraphRepository.fetchEventsStartingToday();
    final firestoreAttendances = await _firestoreRepository.getAttendances();

    final updatedAttendances = SmartMerge(
      currentUser: _currentUser,
      msEvents: msEvents,
      firestoreAttendances: firestoreAttendances,
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
