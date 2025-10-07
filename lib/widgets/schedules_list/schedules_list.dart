import 'package:flutter/material.dart';

import 'package:test_dart/widgets/schedules_list/schedule_item.dart';
import 'package:test_dart/models/schedule.dart';

class SchedulesList extends StatelessWidget {
  const SchedulesList({
    super.key,
    required this.schedules,
    required this.onRemoveSchedule,
  });

  final List<Schedule> schedules;
  final void Function(Schedule schedule) onRemoveSchedule;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: schedules.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(schedules[index]),
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.75),
          margin: EdgeInsets.symmetric(
            horizontal: Theme.of(context).cardTheme.margin!.horizontal,
          ),
        ),
        onDismissed: (direction) {
          onRemoveSchedule(schedules[index]);
        },
        child: ScheduleItem(
          schedules[index],
        ),
      ),
    );
  }
}
