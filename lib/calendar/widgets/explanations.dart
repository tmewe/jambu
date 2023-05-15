import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

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

class _FavoritesExplanation extends StatelessWidget {
  const _FavoritesExplanation({
    required this.onCompleteTap,
  });

  final VoidCallback onCompleteTap;

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
        Image.asset('assets/images/favorites.png'),
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
              onPressed: onCompleteTap,
              child: const Text('Nice'),
            ),
          ],
        ),
      ],
    );
  }
}

class _TagsExplanation extends StatelessWidget {
  const _TagsExplanation({
    required this.onBackTap,
    required this.onCompleteTap,
  });

  final VoidCallback onBackTap;
  final VoidCallback onCompleteTap;

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
        Image.asset('assets/images/tags.png'),
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
              onPressed: onBackTap,
              child: const Text('Zurück'),
            ),
            const SizedBox(width: 10),
            FilledButton(
              onPressed: onCompleteTap,
              child: const Text('Fertig'),
            ),
          ],
        )
      ],
    );
  }
}
