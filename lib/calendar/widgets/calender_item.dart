import 'package:flutter/material.dart';
import 'package:jambu/calendar/model/model.dart';
import 'package:jambu/calendar/widgets/widgets.dart';

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
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
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (context) => TagDialog(
                        onSave: (name) {},
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                ),
                ...user.tags.map(Text.new),
              ],
            )
          ],
        ),
      ),
    );
  }
}
