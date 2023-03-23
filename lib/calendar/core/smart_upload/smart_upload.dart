import 'package:flutter/foundation.dart';
import 'package:jambu/backend/backend.dart';
import 'package:jambu/calendar/core/smart_upload/outlook_upload.dart';
import 'package:jambu/model/model.dart';
import 'package:jambu/ms_graph/model/model.dart';
import 'package:jambu/repository/repository.dart';

class SmartUpload {
  SmartUpload({
    required User currentUser,
    required List<MSEvent> msEvents,
    required List<Attendance> attendances,
    required MSGraphRepository msGraphRepository,
    required FirestoreRepository firestoreRepository,
  })  : _currentUser = currentUser,
        _msEvents = msEvents,
        _attendances = attendances,
        _msGraphRepository = msGraphRepository,
        _firestoreRepository = firestoreRepository;

  final User _currentUser;
  final List<MSEvent> _msEvents;
  final List<Attendance> _attendances;
  final MSGraphRepository _msGraphRepository;
  final FirestoreRepository _firestoreRepository;

  Future<void> call() async {
    debugPrint('Start smart upload');
    await OutlookUpload(
      currentUser: _currentUser,
      msEvents: _msEvents,
      attendances: _attendances,
      msGraphRepository: _msGraphRepository,
    )();

    // TODO(tim): Firestore upload
  }
}
