import 'package:flutter/material.dart';
import 'package:jambu/calendar/model/model.dart';

class CalendarItem extends StatelessWidget {
  const CalendarItem({
    required this.user,
    super.key,
  });

  final CalendarUser user;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Row(
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
      ),
    );
  }
}
