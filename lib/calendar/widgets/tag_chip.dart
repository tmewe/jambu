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
      // child: Text(widget.name),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white30,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                widget.name,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 3),
            Tooltip(
              message: 'Entfernen',
              child: InkWell(
                onTap: widget.onRemove,
                child: const Icon(Icons.clear, size: 15),
              ),
            ),
          ],
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
