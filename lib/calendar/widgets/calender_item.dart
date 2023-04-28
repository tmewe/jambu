import 'package:app_ui/app_ui.dart';
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

class CalendarItem extends StatelessWidget {
  const CalendarItem({
    required this.user,
    required this.tags,
    required this.onAddTag,
    required this.onRemoveTag,
    required this.onUpdateTagName,
    required this.onUpdateFavorite,
    required this.borderRadius,
    super.key,
  });

  final CalendarUser user;
  final List<String> tags;
  final AddTagCallback onAddTag;
  final RemoveTagCallback onRemoveTag;
  final UpdateTagNameCallback onUpdateTagName;
  final UpdateFavoriteCallback onUpdateFavorite;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: AppColors.seasaltGrey,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(user: user, onUpdateFavorite: onUpdateFavorite),
          Padding(
            padding: EdgeInsets.only(
              left: _kPadding,
              top: user.tags.isNotEmpty ? _kPadding : _kPadding / 2,
              right: _kPadding,
            ),
            child: _TagsSection(
              user: user,
              tags: tags,
              onAddTag: onAddTag,
              onRemoveTag: onRemoveTag,
              onUpdateTagName: onUpdateTagName,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: _kPadding,
              right: _kPadding / 2,
              bottom: _kPadding / 2,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    user.tags.isEmpty
                        ? 'Klicke auf das Plus, um Tags hinzuzufügen.'
                        : '',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Colors.black38,
                        ),
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
      color: AppColors.platinumGrey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          _kPadding,
          _kPadding,
          _kPadding / 2,
          _kPadding,
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.slateGrey,
              foregroundImage:
                  user.image != null ? NetworkImage(user.image!) : null,
              radius: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                user.name.split(' ').join('\n'),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w500, height: 1.2),
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
      color: _isFavorite ? AppColors.pink : AppColors.slateGrey,
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
    final sortedTags = user.tags.sorted((a, b) => a.length.compareTo(b.length));
    return Wrap(
      spacing: 8,
      runSpacing: 5,
      children: sortedTags.map(
        (tagName) {
          return TagChip(
            tags: tags,
            name: tagName,
            onRemove: () => onRemoveTag(tagName, user.id),
            onUpdateName: (newName) => onUpdateTagName(tagName, newName),
          );
        },
      ).toList(),
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
      icon: const Icon(Icons.add),
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
              decoration: const InputDecoration(
                hintText: 'Neuer Tag',
                border: InputBorder.none,
              ),
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
