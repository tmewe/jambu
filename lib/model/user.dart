import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

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
  });

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
      favorites: List.from(data?['favorites'] as Iterable),
      tags: List.from(data?['tags'] as Iterable),
    );
  }

  final String id;
  final String name;
  final String email;
  final String? imageUrl;
  final String? jobTitle;
  final List<String> favorites;
  final List<String> tags;

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
      'jobTitle': jobTitle,
      'favorites': favorites,
      'tags': tags,
    };
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email imageUrl: $imageUrl, '
        ' jobTitle: $jobTitle, favorites: $favorites, tags: $tags)';
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? imageUrl,
    String? jobTitle,
    List<String>? favorites,
    List<String>? tags,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      jobTitle: jobTitle ?? this.jobTitle,
      favorites: favorites ?? this.favorites,
      tags: tags ?? this.tags,
    );
  }

  @override
  List<Object> get props => [id, name, email, favorites, tags];
}
