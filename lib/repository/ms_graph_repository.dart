import 'package:flutter/material.dart';
import 'package:jambu/ms_graph/ms_graph.dart';

class MSGraphRepository {
  MSGraphRepository({
    required MSGraphDataSource msGraphDataSource,
  }) : _msGraphDataSource = msGraphDataSource;

  final MSGraphDataSource _msGraphDataSource;

  Future<void> me() async {
    final response = await _msGraphDataSource.me();
    debugPrint('$response');
  }

  Future<void> events() async {
    final events = await _msGraphDataSource.events();
    debugPrint('$events');
  }
}
