import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {
  const TagChip({
    required this.name,
    required this.onRemove,
    super.key,
  });

  final String name;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white30,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(name),
          const SizedBox(width: 3),
          InkWell(
            onTap: onRemove,
            child: const Icon(Icons.clear, size: 15),
          )
        ],
      ),
    );
  }
}
