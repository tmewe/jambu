import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jambu/calendar/model/model.dart';
import 'package:jambu/calendar/widgets/tag_chip.dart';

typedef AddTagCallback = void Function(String, String);
typedef RemoveTagCallback = void Function(String, String);
typedef UpdateTagNameCallback = void Function(String, String);
typedef UpdateFavoriteCallback = void Function(bool);

class CalendarItem extends StatelessWidget {
  const CalendarItem({
    required this.user,
    required this.tags,
    required this.onAddTag,
    required this.onRemoveTag,
    required this.onUpdateTagName,
    required this.onUpdateFavorite,
    super.key,
  });

  final CalendarUser user;
  final List<String> tags;
  final AddTagCallback onAddTag;
  final RemoveTagCallback onRemoveTag;
  final UpdateTagNameCallback onUpdateTagName;
  final UpdateFavoriteCallback onUpdateFavorite;

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
                Flexible(
                  child: Text(
                    user.name,
                    maxLines: 3,
                  ),
                ),
                _FavoriteButton(
                  isFavorite: user.isFavorite,
                  onTap: onUpdateFavorite,
                ),
              ],
            ),
            _TagsSection(
              user: user,
              tags: tags,
              onAddTag: onAddTag,
              onRemoveTag: onRemoveTag,
              onUpdateTagName: onUpdateTagName,
            ),
          ],
        ),
      ),
    );
  }
}

typedef FavoriteCallback = void Function(bool);

class _FavoriteButton extends StatefulWidget {
  const _FavoriteButton({
    required this.isFavorite,
    required this.onTap,
  });

  final bool isFavorite;
  final FavoriteCallback onTap;

  @override
  // ignore: no_logic_in_create_state
  State<_FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<_FavoriteButton> {
  var _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  @override
  void didUpdateWidget(covariant _FavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isFavorite = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() => _isFavorite = !_isFavorite);
        widget.onTap(_isFavorite);
      },
      icon: const Icon(Icons.favorite),
      color: _isFavorite ? Colors.orange : Colors.white24,
    );
  }
}

class _TagsSection extends StatelessWidget {
  const _TagsSection({
    required this.user,
    required this.tags,
    required this.onAddTag,
    required this.onRemoveTag,
    required this.onUpdateTagName,
  });

  final CalendarUser user;
  final List<String> tags;
  final AddTagCallback onAddTag;
  final RemoveTagCallback onRemoveTag;
  final UpdateTagNameCallback onUpdateTagName;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      verticalDirection: VerticalDirection.up,
      spacing: 8,
      runSpacing: 5,
      children: [
        ...user.tags.map(
          (tagName) => TagChip(
            tags: tags,
            name: tagName,
            onRemove: () => onRemoveTag(tagName, user.id),
            onUpdateName: (newName) => onUpdateTagName(tagName, newName),
          ),
        ),
        _TagButton(
          user: user,
          tags: tags,
          onAddTag: onAddTag,
          onRemoveTag: onRemoveTag,
        ),
      ],
    );
  }
}

class _TagButton extends StatelessWidget {
  const _TagButton({
    required this.user,
    required this.tags,
    required this.onAddTag,
    required this.onRemoveTag,
  });

  final CalendarUser user;
  final List<String> tags;
  final AddTagCallback onAddTag;
  final RemoveTagCallback onRemoveTag;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      position: PopupMenuPosition.under,
      icon: const Icon(Icons.add_circle),
      tooltip: 'Tag hinzufügen',
      onSelected: (String? value) {
        if (value == null || value.isEmpty) return;
        onAddTag(value, user.id);
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem<String?>(
            child: TextField(
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Neuer Tag'),
              onSubmitted: (String text) {
                if (text.isEmpty) return;
                onAddTag(text, user.id);
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
    );
  }
}
