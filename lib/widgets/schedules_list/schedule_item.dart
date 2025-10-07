import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 引入intl库

import 'package:test_dart/models/schedule.dart';

class ScheduleItem extends StatelessWidget {
  const ScheduleItem(this.schedule, {super.key});

  final Schedule schedule;

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
              schedule.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Spacer(),
                Text(DateFormat.Hm().format(schedule.date)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
