import 'package:flutter/material.dart';
import 'package:jambu/ms_graph/api/ms_graph_api.dart';

class MSGraphRepository {
  MSGraphRepository({
    required MSGraphAPI msGraphAPI,
  }) : _msGraphAPI = msGraphAPI;

  final MSGraphAPI _msGraphAPI;

  Future<void> me() async {
    final response = await _msGraphAPI.me();
    debugPrint('$response');
  }
}
