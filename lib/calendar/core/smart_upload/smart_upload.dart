import 'dart:async';

import 'package:jambu/backend/backend.dart';
import 'package:jambu/calendar/core/smart_upload/firestore_upload.dart';
import 'package:jambu/calendar/core/smart_upload/outlook_upload.dart';
import 'package:jambu/model/model.dart';
import 'package:jambu/ms_graph/ms_graph.dart';

class SmartUpload {
  SmartUpload({
    required User currentUser,
    required List<MSEvent> msEvents,
    required List<Attendance> updatedAttendances,
    required MSGraphRepository msGraphRepository,
    required FirestoreRepository firestoreRepository,
  })  : _currentUser = currentUser,
        _msEvents = msEvents,
        _updatedAttendances = updatedAttendances,
        _msGraphRepository = msGraphRepository,
        _firestoreRepository = firestoreRepository;

  final User _currentUser;
  final List<MSEvent> _msEvents;
  final List<Attendance> _updatedAttendances;
  final MSGraphRepository _msGraphRepository;
  final FirestoreRepository _firestoreRepository;

  Future<void> call() async {
    unawaited(
      OutlookUpload(
        currentUser: _currentUser,
        msEvents: _msEvents,
        attendances: _updatedAttendances,
        msGraphRepository: _msGraphRepository,
      )(),
    );

    await FirestoreUpload(
      currentUser: _currentUser,
      updatedAttendances: _updatedAttendances,
      firestoreRepository: _firestoreRepository,
    )();
  }
}
