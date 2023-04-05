import 'package:flutter/material.dart';

class WeekdaySelector extends StatelessWidget {
  const WeekdaySelector({
    required this.weekday,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final bool isSelected;
  final String weekday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Material(
        color: isSelected ? Colors.green : Colors.transparent,
        shape: CircleBorder(
          side: BorderSide(
            width: 3,
            color: isSelected ? Colors.green : Colors.grey,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Ink(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  weekday,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: isSelected ? Colors.white : Colors.grey,
                      ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
