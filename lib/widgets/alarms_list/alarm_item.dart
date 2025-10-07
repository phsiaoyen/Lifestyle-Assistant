import 'package:flutter/material.dart';

import 'package:test_dart/models/alarm.dart';

class AlarmItem extends StatelessWidget {
  const AlarmItem(this.alarm, this.date, {super.key});

  final Alarm alarm;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              alarm.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Spacer(),
                if(alarm.times[date.weekday%7] != null) Text(alarm.times[date.weekday%7]!.format(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
