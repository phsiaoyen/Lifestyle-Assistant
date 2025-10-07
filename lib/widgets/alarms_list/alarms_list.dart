import 'package:flutter/material.dart';

import 'package:test_dart/widgets/alarms_list/alarm_item.dart';
import 'package:test_dart/models/alarm.dart';

class AlarmsList extends StatelessWidget {
  const AlarmsList({
    super.key,
    required this.alarms,
    required this.onRemoveAlarm,
    required this.date,
  });

  final List<Alarm> alarms;
  final void Function(Alarm alarm) onRemoveAlarm;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: alarms.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(alarms[index]),
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.75),
          margin: EdgeInsets.symmetric(
            horizontal: Theme.of(context).cardTheme.margin!.horizontal,
          ),
        ),
        onDismissed: (direction) {
          onRemoveAlarm(alarms[index]);
        },
        child: AlarmItem(
          alarms[index],
          date,
        ),
      ),
    );
  }
}
