// ignore_for_file: sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:jambu/constants.dart';
import 'package:jambu/model/tag.dart';

@immutable
class User extends Equatable {
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.imageUrl,
    this.jobTitle,
    this.favorites = const [],
    this.tags = const [],
    this.regularAttendances = const [],
    this.manualAbsences = const [],
    this.onboardingCompleted = false,
    this.explanationsCompleted = false,
    this.isColorBlind = false,
  });

  final String id;
  final String name;
  final String email;
  final String? imageUrl;
  final String? jobTitle;
  final List<String> favorites;
  final List<Tag> tags;
  final List<int> regularAttendances; // In weekdays 1 - 7
  final List<DateTime> manualAbsences;
  final bool onboardingCompleted;
  final bool explanationsCompleted;
  final bool isColorBlind;

  factory User.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return User(
      id: data?['id'] as String,
      name: data?['name'] as String,
      email: data?['email'] as String,
      imageUrl: data?['imageUrl'] as String?,
      jobTitle: data?['jobTitle'] as String?,
      favorites: List.from(data?[Constants.favoritesField] as Iterable),
      tags: List<Map<String, dynamic>>.from(data?['tags'] as Iterable)
          .map(Tag.fromMap)
          .toList(),
      regularAttendances: List.from(data?['regularAttendances'] as Iterable),
      manualAbsences: List.from(
        (data?['manualAbsences'] as Iterable)
            .map((e) => (e as Timestamp).toDate()),
      ),
      onboardingCompleted: data?['onboardingCompleted'] as bool? ?? false,
      explanationsCompleted: data?['explanationsCompleted'] as bool? ?? false,
      isColorBlind: data?['isColorBlind'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
      'jobTitle': jobTitle,
      'favorites': favorites,
      'tags': tags.map((t) => t.toMap()),
      'regularAttendances': regularAttendances,
      'manualAbsences': manualAbsences.map(Timestamp.fromDate),
      'onboardingCompleted': onboardingCompleted,
      'explanationsCompleted': explanationsCompleted,
      'isColorBlind': isColorBlind,
    };
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email imageUrl: $imageUrl, '
        ' jobTitle: $jobTitle, favorites: $favorites, tags: $tags) '
        'regularAttendances: $regularAttendances, '
        'manualAbsences: $manualAbsences, '
        'onboardingCompleted: $onboardingCompleted, '
        'explanationsCompleted: $explanationsCompleted '
        'isColorBlind: $isColorBlind';
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? imageUrl,
    String? jobTitle,
    List<String>? favorites,
    List<Tag>? tags,
    List<int>? regularAttendances,
    List<DateTime>? manualAbsences,
    bool? onboardingCompleted,
    bool? explanationsCompleted,
    bool? isColorBlind,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      jobTitle: jobTitle ?? this.jobTitle,
      favorites: favorites ?? this.favorites,
      tags: tags ?? this.tags,
      regularAttendances: regularAttendances ?? this.regularAttendances,
      manualAbsences: manualAbsences ?? this.manualAbsences,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      explanationsCompleted:
          explanationsCompleted ?? this.explanationsCompleted,
      isColorBlind: isColorBlind ?? this.isColorBlind,
    );
  }

  @override
  List<Object> get props => [
        id,
        name,
        email,
        favorites,
        tags,
        regularAttendances,
        manualAbsences,
        onboardingCompleted,
        explanationsCompleted,
        isColorBlind,
      ];
}
