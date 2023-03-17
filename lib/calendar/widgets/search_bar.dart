import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    required this.controller,
    required this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: _inputDecoration,
      onChanged: onChanged,
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
      hintText: 'Suche',
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
