import 'package:flutter/material.dart';
import 'package:jambu/calendar/model/model.dart';

class CalendarItemWidget extends StatelessWidget {
  const CalendarItemWidget({
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
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Row(
          children: [
            Text(user.name),
          ],
        ),
      ),
    );
  }
}
