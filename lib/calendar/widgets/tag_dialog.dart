import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

typedef StringCallback = void Function(String);

class TagDialog extends StatefulWidget {
  const TagDialog({
    required this.onSave,
    super.key,
  });

  final StringCallback onSave;

  @override
  State<TagDialog> createState() => _TagDialogState();
}

class _TagDialogState extends State<TagDialog> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Tag anlegen/bearbeiten'),
            TextField(
              autofocus: true,
              controller: textController,
              onSubmitted: (text) {
                widget.onSave(text);
                context.pop();
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text('Abbrechen'),
        ),
        TextButton(
          onPressed: () {
            widget.onSave(textController.text);
            context.pop();
          },
          child: const Text('Speichern'),
        ),
      ],
    );
  }
}
