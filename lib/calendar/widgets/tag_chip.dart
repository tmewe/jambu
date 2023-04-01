import 'package:flutter/material.dart';

class TagChip extends StatefulWidget {
  const TagChip({
    required this.name,
    required this.onRemove,
    super.key,
  });

  final String name;
  final VoidCallback onRemove;

  @override
  State<TagChip> createState() => _TagChipState();
}

class _TagChipState extends State<TagChip> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isHovering ? Colors.white54 : Colors.white30,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SelectableText(widget.name),
            const SizedBox(width: 3),
            InkWell(
              onTap: widget.onRemove,
              child: const Icon(Icons.clear, size: 15),
            ),
          ],
        ),
      ),
    );
  }
}
