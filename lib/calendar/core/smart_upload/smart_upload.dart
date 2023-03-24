import 'package:flutter/foundation.dart';
import 'package:jambu/backend/backend.dart';
import 'package:jambu/calendar/core/smart_upload/firestore_upload.dart';
import 'package:jambu/calendar/core/smart_upload/outlook_upload.dart';
import 'package:jambu/model/model.dart';
import 'package:jambu/ms_graph/model/model.dart';
import 'package:jambu/repository/repository.dart';

class SmartUpload {
  SmartUpload({
    required User currentUser,
    required List<MSEvent> msEvents,
    required List<Attendance> oldAttendances,
    required List<Attendance> updatedAttendances,
    required MSGraphRepository msGraphRepository,
    required FirestoreRepository firestoreRepository,
  })  : _currentUser = currentUser,
        _msEvents = msEvents,
        _oldAttendances = oldAttendances,
        _updatedAttendances = updatedAttendances,
        _msGraphRepository = msGraphRepository,
        _firestoreRepository = firestoreRepository;

  final User _currentUser;
  final List<MSEvent> _msEvents;
  final List<Attendance> _oldAttendances;
  final List<Attendance> _updatedAttendances;
  final MSGraphRepository _msGraphRepository;
  final FirestoreRepository _firestoreRepository;

  Future<void> call() async {
    await OutlookUpload(
      currentUser: _currentUser,
      msEvents: _msEvents,
      attendances: _updatedAttendances,
      msGraphRepository: _msGraphRepository,
    )();

    await FirestoreUpload(
      currentUser: _currentUser,
      oldAttendances: _oldAttendances,
      updatedAttendances: _updatedAttendances,
      firestoreRepository: _firestoreRepository,
    )();
  }
}
