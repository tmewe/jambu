import 'package:jambu/backend/backend.dart';
import 'package:jambu/calendar/core/smart_merge/smart_merge.dart';
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
    final msEvents = await _msGraphRepository.eventsFromToday();
    final firestoreAttendances = await _firestoreRepository.getAttendances();

    final attendances = SmartMerge(
      currentUser: _currentUser,
      msEvents: msEvents,
      firestoreAttendances: firestoreAttendances,
    )();

    return attendances;
  }
}
