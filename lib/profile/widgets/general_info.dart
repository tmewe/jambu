import 'package:flutter/material.dart';
import 'package:jambu/model/model.dart';

class GeneralInfo extends StatelessWidget {
  const GeneralInfo({
    required this.user,
    super.key,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          foregroundImage: NetworkImage(user.imageUrl!),
          radius: 60,
          child: Text(user.name.characters.first),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 5),
            Text(
              user.jobTitle ?? '',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ],
    );
  }
}
