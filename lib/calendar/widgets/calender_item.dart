import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jambu/calendar/model/model.dart';
import 'package:jambu/calendar/widgets/tag_chip.dart';

typedef AddTagCallback = void Function(String, String);
typedef RemoveTagCallback = void Function(String, String);
typedef UpdateTagNameCallback = void Function(String, String);
typedef UpdateFavoriteCallback = void Function(bool);

const _kPadding = 16.0;
const _kMinTagSectionHeight = 80.0;

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
    return Card(
      clipBehavior: Clip.hardEdge,
      color: Colors.grey.shade100,
      elevation: 0,
      child: Column(
        children: [
          _Header(user: user, onUpdateFavorite: onUpdateFavorite),
          Padding(
            padding: const EdgeInsets.all(_kPadding),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: _kMinTagSectionHeight,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.user,
    required this.onUpdateFavorite,
  });

  final CalendarUser user;
  final UpdateFavoriteCallback onUpdateFavorite;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.grey.shade300,
      child: Padding(
        padding: const EdgeInsets.all(_kPadding),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.2),
              foregroundImage:
                  user.image != null ? NetworkImage(user.image!) : null,
              radius: 25,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                user.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            _FavoriteButton(
              isFavorite: user.isFavorite,
              onTap: onUpdateFavorite,
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
      color: _isFavorite ? Colors.orange : Colors.grey,
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
    final sortedTags = user.tags.sorted((a, b) => b.length.compareTo(a.length));
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Wrap(
          alignment: WrapAlignment.end,
          crossAxisAlignment: WrapCrossAlignment.center,
          verticalDirection: VerticalDirection.up,
          spacing: 8,
          runSpacing: 5,
          children: [
            ...sortedTags.map(
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
        ),
        if (sortedTags.isEmpty)
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(right: 55),
              child: Text(
                'Hier könnten deine Tags stehen.',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(fontStyle: FontStyle.italic),
              ),
            ),
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
