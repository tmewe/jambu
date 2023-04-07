import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:jambu/constants.dart';
import 'package:jambu/extension/extension.dart';
import 'package:jambu/model/model.dart';

class FirestoreDatasource {
  FirestoreDatasource({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  Future<List<User>> getUsers() async {
    final querySnaphot =
        await _firestore.collection(Constants.usersCollection).get();
    final users = querySnaphot.docs.map(User.fromFirestore);
    return users.toList();
  }

  Future<void> updateUser(User user) async {
    return _firestore
        .collection(Constants.usersCollection)
        .doc(user.id)
        .set(user.toFirestore());
  }

  Future<List<Attendance>> getAttendances() async {
    final querySnaphot =
        await _firestore.collection(Constants.attendancesCollection).get();
    final attendances = querySnaphot.docs.map(Attendance.fromFirestore);
    return attendances.toList();
  }

  Future<void> updateAttendanceAt({
    required DateTime date,
    required bool isAttending,
    required User user,
    String? reason,
  }) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date.midnight);

    final attendanceRef = _firestore
        .collection(Constants.attendancesCollection)
        .doc(formattedDate);

    await _firestore.runTransaction((transaction) async {
      final snaphot = await transaction.get(attendanceRef);

      if (snaphot.exists) {
        final attendance = Attendance.fromFirestore(snaphot);

        final updatedAttendance = _updateExistingAttendance(
          isAttending: isAttending,
          attendance: attendance,
          userId: user.id,
          reason: reason,
        );

        transaction.update(attendanceRef, updatedAttendance.toFirestore());
      } else {
        final entry = Entry(userId: user.id, reason: reason);
        final attendance = Attendance(
          date: date.midnight,
          present: isAttending ? [entry] : [],
          absent: !isAttending ? [entry] : [],
        );
        transaction.set(attendanceRef, attendance.toFirestore());
      }
    });
  }

  Future<void> updateManualAbsences({
    required DateTime date,
    required String userId,
    required bool add,
  }) async {
    final fieldValue = add
        ? FieldValue.arrayUnion([Timestamp.fromDate(date)])
        : FieldValue.arrayRemove([Timestamp.fromDate(date)]);
    final ref = _firestore.collection(Constants.usersCollection).doc(userId);
    await ref.update({'manualAbsences': fieldValue});
  }

  Future<User?> addTagToUser({
    required String tagName,
    required String currentUserId,
    required String tagUserId,
  }) async {
    final userRef =
        _firestore.collection(Constants.usersCollection).doc(currentUserId);

    User? updatedUser;
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);
      final user = User.fromFirestore(snapshot);
      final existingTag = user.tags.firstWhereOrNull(
        (tag) => tag.name == tagName,
      );
      Tag? tag;

      // Tag doesn't exist -> create new tag
      if (existingTag == null || !user.tags.remove(existingTag)) {
        tag = Tag(name: tagName, userIds: [tagUserId]);
      }
      // Tag exists -> Add user id to tag
      else {
        tag = existingTag.copyWith(
          userIds: [...existingTag.userIds, tagUserId],
        );
      }

      updatedUser = user.copyWith(tags: [...user.tags, tag]);
      transaction.set(userRef, updatedUser?.toFirestore());
    });
    return updatedUser;
  }

  Future<User?> removeTagFromUser({
    required String tagName,
    required String currentUserId,
    required String tagUserId,
  }) async {
    final userRef =
        _firestore.collection(Constants.usersCollection).doc(currentUserId);

    User? updatedUser;
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);
      final user = User.fromFirestore(snapshot);
      final existingTag = user.tags.firstWhereOrNull(
        (tag) => tag.name == tagName,
      );
      if (existingTag == null || !user.tags.remove(existingTag)) return;

      final updatedTag = existingTag.copyWith(
        userIds: existingTag.userIds.where((id) => id != tagUserId).toList(),
      );

      updatedUser = user.copyWith(tags: [...user.tags, updatedTag]);
      transaction.set(userRef, updatedUser?.toFirestore());
    });
    return updatedUser;
  }

  Future<User?> updateTagName({
    required String tagName,
    required String newTagName,
    required String userId,
  }) async {
    final userRef =
        _firestore.collection(Constants.usersCollection).doc(userId);

    User? updatedUser;
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);
      final user = User.fromFirestore(snapshot);
      final existingTag = user.tags.firstWhereOrNull(
        (tag) => tag.name == tagName,
      );
      if (existingTag == null || !user.tags.remove(existingTag)) return;

      final updatedTag = existingTag.copyWith(name: newTagName);
      updatedUser = user.copyWith(tags: [...user.tags, updatedTag]);
      transaction.set(userRef, updatedUser?.toFirestore());
    });
    return updatedUser;
  }

  Future<void> addFavorite({
    required String currentUserId,
    required String favoriteUserId,
  }) async {
    final userRef =
        _firestore.collection(Constants.usersCollection).doc(currentUserId);
    await userRef.update({
      Constants.favoritesField: FieldValue.arrayUnion([favoriteUserId])
    });
  }

  Future<void> removeFavorite({
    required String currentUserId,
    required String favoriteUserId,
  }) async {
    final userRef =
        _firestore.collection(Constants.usersCollection).doc(currentUserId);
    await userRef.update({
      Constants.favoritesField: FieldValue.arrayRemove([favoriteUserId])
    });
  }

  Future<void> completeOnboarding({required String userId}) async {
    final userRef =
        _firestore.collection(Constants.usersCollection).doc(userId);
    await userRef.update({Constants.onboardingCompletedField: true});
  }

  Future<void> updateRegularAttendances({
    required String userId,
    required List<int> weekdays,
  }) async {
    final userRef =
        _firestore.collection(Constants.usersCollection).doc(userId);
    await userRef.update({Constants.regularAttendancesField: weekdays});
  }

  Attendance _updateExistingAttendance({
    required Attendance attendance,
    required bool isAttending,
    required String userId,
    String? reason,
  }) {
    final present = _updatePresent(
      isAttending: isAttending,
      attendance: attendance,
      reason: reason,
      userId: userId,
    );

    final absent = _updateAbsent(
      isAttending: isAttending,
      attendance: attendance,
      reason: reason,
      userId: userId,
    );

    final updatedAttendance = attendance.copyWith(
      present: present.toSet().toList(),
      absent: absent.toSet().toList(),
    );

    return updatedAttendance;
  }

  List<Entry> _updatePresent({
    required bool isAttending,
    required Attendance attendance,
    required String userId,
    String? reason,
  }) {
    if (isAttending) {
      return [
        ...attendance.present.where((a) => a.userId != userId),
        Entry(userId: userId, reason: reason),
      ];
    } else {
      return attendance.present.where((a) => a.userId != userId).toList();
    }
  }

  List<Entry> _updateAbsent({
    required bool isAttending,
    required Attendance attendance,
    required String userId,
    String? reason,
  }) {
    if (!isAttending) {
      return [
        ...attendance.absent.where((a) => a.userId != userId),
        Entry(userId: userId, reason: reason),
      ];
    } else {
      return attendance.absent.where((a) => a.userId != userId).toList();
    }
  }
}
