import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jambu/calendar/model/model.dart';
import 'package:jambu/calendar/widgets/tag_chip.dart';

typedef CreateTagCallback = void Function(String, String);
typedef RemoveTagCallback = void Function(String, String);

class CalendarItem extends StatelessWidget {
  const CalendarItem({
    required this.user,
    required this.tags,
    required this.onCreate,
    required this.onRemove,
    super.key,
  });

  final CalendarUser user;
  final List<String> tags;
  final CreateTagCallback onCreate;
  final RemoveTagCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.2),
                  foregroundImage:
                      user.image != null ? NetworkImage(user.image!) : null,
                  radius: 30,
                ),
                const SizedBox(width: 10),
                Text(user.name),
              ],
            ),
            _TagsSection(
              user: user,
              tags: tags,
              onCreate: onCreate,
              onRemove: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}

class _TagsSection extends StatelessWidget {
  const _TagsSection({
    required this.user,
    required this.tags,
    required this.onCreate,
    required this.onRemove,
  });

  final CalendarUser user;
  final List<String> tags;
  final CreateTagCallback onCreate;
  final RemoveTagCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Wrap(
            alignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 5,
            children: user.tags
                .map(
                  (tag) => TagChip(
                    name: tag,
                    onRemove: () => onRemove(tag, user.id),
                  ),
                )
                .toList(),
          ),
        ),
        _TagButton(
          user: user,
          tags: tags,
          onCreate: onCreate,
          onRemove: onRemove,
        ),
      ],
    );
  }
}

class _TagButton extends StatelessWidget {
  const _TagButton({
    required this.user,
    required this.tags,
    required this.onCreate,
    required this.onRemove,
  });

  final CalendarUser user;
  final List<String> tags;
  final CreateTagCallback onCreate;
  final RemoveTagCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 25,
      height: 25,
      child: PopupMenuButton(
        icon: const Icon(Icons.sell),
        iconSize: 20,
        padding: const EdgeInsets.all(3.5),
        tooltip: 'Tag hinzufügen',
        onSelected: (String? value) {
          if (value == null) return;
          onCreate(value, user.id);
        },
        itemBuilder: (context) {
          return [
            PopupMenuItem<String?>(
              child: TextField(
                autofocus: true,
                onSubmitted: (String text) {
                  if (text.isEmpty) return;
                  onCreate(text, user.id);
                  context.pop();
                },
              ),
            ),
            ...tags.where((t) => !user.tags.contains(t)).map(
                  (tag) => PopupMenuItem(
                    value: tag,
                    child: Row(
                      children: [
                        const Icon(Icons.sell_outlined),
                        const SizedBox(width: 10),
                        Text(tag),
                      ],
                    ),
                  ),
                )
          ];
        },
      ),
    );
  }
}
