import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    required this.controller,
    super.key,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(16),
        filled: true,
        hintText: 'Suche',
        prefixIcon: const Icon(
          Icons.search,
          size: 24,
        ),
        suffixIcon: const Icon(
          Icons.close,
          size: 24,
        ),
      ),
    );
  }
}
