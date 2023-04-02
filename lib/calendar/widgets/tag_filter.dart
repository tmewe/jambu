import 'package:flutter/material.dart';

typedef ChipTapCallback = void Function(String, bool);

class TagFilter extends StatelessWidget {
  const TagFilter({
    required this.tags,
    required this.selectedTags,
    required this.onSelectTag,
    this.padding = EdgeInsets.zero,
    super.key,
  });

  final List<String> tags;
  final EdgeInsets padding;
  final List<String> selectedTags;
  final ChipTapCallback onSelectTag;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Wrap(
        spacing: 5,
        runSpacing: 5,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Icon(Icons.sell),
          ...tags.map((tag) {
            return FilterChip(
              label: Text(tag),
              selected: selectedTags.contains(tag),
              onSelected: (isSelected) => onSelectTag(tag, isSelected),
            );
          })
        ],
      ),
    );
  }
}
