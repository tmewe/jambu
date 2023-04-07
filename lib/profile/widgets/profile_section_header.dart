import 'package:flutter/material.dart';

class ProfileSectionHeader extends StatelessWidget {
  const ProfileSectionHeader({
    required this.text,
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.titleLarge);
  }
}
