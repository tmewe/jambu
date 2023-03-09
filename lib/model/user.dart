// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class User extends Equatable {
  const User({
    required this.id,
    required this.name,
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
      favorites: List.from(data?['favorites'] as Iterable),
      tags: List.from(data?['tags'] as Iterable),
    );
  }

  final String id;
  final String name;
  final List<String> favorites;
  final List<String> tags;

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'favorites': favorites,
      'tags': tags,
    };
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, favorites: $favorites, tags: $tags)';
  }

  User copyWith({
    String? id,
    String? name,
    List<String>? favorites,
    List<String>? tags,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      favorites: favorites ?? this.favorites,
      tags: tags ?? this.tags,
    );
  }

  @override
  List<Object> get props => [id, name, favorites, tags];
}
