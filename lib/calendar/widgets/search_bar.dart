import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    required this.controller,
    required this.onChanged,
    this.padding = EdgeInsets.zero,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextField(
        controller: controller,
        decoration: _inputDecoration,
        onChanged: onChanged,
      ),
    );
  }

  InputDecoration get _inputDecoration {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.all(16),
      filled: true,
      hintText: 'Suche nach jambitees',
      prefixIcon: const Icon(
        Icons.search,
        size: 24,
      ),
      suffixIcon: controller.text.isNotEmpty ? _clearButton : null,
    );
  }

  Widget get _clearButton {
    return InkWell(
      child: const Icon(
        Icons.close,
        size: 24,
      ),
      onTap: () {
        onChanged('');
        controller.clear();
      },
    );
  }
}
