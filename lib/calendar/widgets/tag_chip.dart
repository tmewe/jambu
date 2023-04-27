import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

typedef UpdateTagNameCallback = void Function(String);

class TagChip extends StatefulWidget {
  const TagChip({
    required this.tags,
    required this.name,
    required this.onRemove,
    required this.onUpdateName,
    super.key,
  });

  final List<String> tags;
  final String name;
  final VoidCallback onRemove;
  final UpdateTagNameCallback onUpdateName;

  @override
  State<TagChip> createState() => _TagChipState();
}

class _TagChipState extends State<TagChip> {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      tooltip: 'Bearbeiten',
      position: PopupMenuPosition.under,
      onOpened: () => _textController.text = widget.name,
      itemBuilder: (context) => [
        PopupMenuItem<String?>(
          child: ValueListenableBuilder(
            valueListenable: _textController,
            builder: (context, _, __) {
              return TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.edit, size: 18),
                  errorText: _errorText,
                ),
                controller: _textController,
                autofocus: true,
                onSubmitted: (String text) {
                  if (text.isEmpty || _errorText != null) return;
                  widget.onUpdateName(text);
                  context.pop();
                },
              );
            },
          ),
        ),
      ],
      child: Ink(
        child: Chip(
          label: Text(
            widget.name,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          deleteIcon: const Icon(Icons.clear, size: 15),
          deleteButtonTooltipMessage: 'Entfernen',
          onDeleted: widget.onRemove,
        ),
      ),
    );
  }

  String? get _errorText {
    final text = _textController.text;
    if (text.isEmpty) {
      return 'Leerer Text';
    } else if (widget.tags.contains(text)) {
      return 'Tag existiert';
    }
    return null;
  }
}
