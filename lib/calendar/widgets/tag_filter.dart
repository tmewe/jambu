import 'package:flutter/material.dart';

class TagFilter extends StatelessWidget {
  const TagFilter({
    required this.tags,
    required this.selectedTags,
    super.key,
  });

  final List<String> tags;
  final List<String> selectedTags;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Icon(Icons.sell),
        ...tags.map((tag) {
          return FilterChip(
            label: Text(tag),
            onSelected: (_) {},
          );
        })
      ],
    );
  }
}
