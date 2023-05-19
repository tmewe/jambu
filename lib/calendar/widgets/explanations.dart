import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ExplanationsAlert extends StatefulWidget {
  const ExplanationsAlert({
    required this.onCompleteTap,
    super.key,
  });

  final VoidCallback onCompleteTap;

  @override
  State<ExplanationsAlert> createState() => _ExplanationsAlertState();
}

class _ExplanationsAlertState extends State<ExplanationsAlert> {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: ConstrainedBox(
        constraints: BoxConstraints.tight(const Size(550, 650)),
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _FavoritesExplanation(
              onCompleteTap: () => _pageController.nextPage(
                duration: PageTransition.duration,
                curve: PageTransition.curve,
              ),
            ),
            _TagsExplanation(
              onBackTap: () => _pageController.previousPage(
                duration: PageTransition.duration,
                curve: PageTransition.curve,
              ),
              onCompleteTap: widget.onCompleteTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoritesExplanation extends StatefulWidget {
  const _FavoritesExplanation({
    required this.onCompleteTap,
  });

  final VoidCallback onCompleteTap;

  @override
  State<_FavoritesExplanation> createState() => _FavoritesExplanationState();
}

class _FavoritesExplanationState extends State<_FavoritesExplanation> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController =
        VideoPlayerController.asset('assets/videos/favorites.mp4')
          ..initialize().then((_) async {
            setState(() {});
            await _videoController.setVolume(0);
            await _videoController.setLooping(true);
            await _videoController.play();
          });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        SelectableText(
          'Favoriten',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 20),
        if (_videoController.value.isInitialized)
          AspectRatio(
            aspectRatio: _videoController.value.aspectRatio,
            child: VideoPlayer(_videoController),
          )
        else
          Container(),
        const SizedBox(height: 20),
        const SelectableText(
          'Mit dem Herz kannst du bestimmte Kolleg*innen '
          'favorisieren. Diese erscheinen dann immer oben '
          'in deiner Übersicht. Außerdem zeigt dir jambu auf '
          'Basis deiner Favoriten an, welche Tage die optimalen '
          'Bürotage für dich wären.',
        ),
        const SizedBox(height: 5),
        const SelectableText(
          'Für einen noch schnelleren Überblick werden deine '
          'Favoriten mit Outlook gesynct.',
        ),
        const Spacer(),
        Row(
          children: [
            const Spacer(),
            FilledButton(
              onPressed: widget.onCompleteTap,
              child: const Text('Nice'),
            ),
          ],
        ),
      ],
    );
  }
}

class _TagsExplanation extends StatefulWidget {
  const _TagsExplanation({
    required this.onBackTap,
    required this.onCompleteTap,
  });

  final VoidCallback onBackTap;
  final VoidCallback onCompleteTap;

  @override
  State<_TagsExplanation> createState() => _TagsExplanationState();
}

class _TagsExplanationState extends State<_TagsExplanation> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/videos/tags.mp4')
      ..initialize().then((_) async {
        setState(() {});
        await _videoController.setVolume(0);
        await _videoController.setLooping(true);
        await _videoController.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        SelectableText(
          'Tägs',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 20),
        if (_videoController.value.isInitialized)
          AspectRatio(
            aspectRatio: _videoController.value.aspectRatio,
            child: VideoPlayer(_videoController),
          )
        else
          Container(),
        const SizedBox(height: 20),
        const SelectableText(
          'Mit dem Plus kannst du bestimmten Kolleg*innen Tägs zuordnen '
          "und auf diese Art und Weise gruppieren. Mit dem 'X' wird der Täg "
          'von der Nutzer*in entfernt. Wenn du einen Täg komplett '
          'löschen möchtest, geht das über dein Profil. Tägs umbennen kannst '
          'du einfach per Klick auf den Täg.',
        ),
        const SizedBox(height: 5),
        const SelectableText(
          'Sowohl deine Favoriten, als auch deine Tägs sind personalisiert '
          'und somit nur für dich einsehbar.',
        ),
        const SizedBox(height: 5),
        const SelectableText(
          'Für einen noch schnelleren Überblick werden deine '
          'Tägs mit Outlook gesynct.',
        ),
        const Spacer(),
        Row(
          children: [
            const Spacer(),
            TextButton(
              onPressed: widget.onBackTap,
              child: const Text('Zurück'),
            ),
            const SizedBox(width: 10),
            FilledButton(
              onPressed: widget.onCompleteTap,
              child: const Text('Fertig'),
            ),
          ],
        )
      ],
    );
  }
}
