import 'package:test_dart/widgets/new_schedule.dart';
import 'package:test_dart/widgets/new_alarm.dart';
import 'package:test_dart/widgets/new_alarm_temp.dart';


import 'package:flutter/material.dart';

import 'package:test_dart/widgets/schedules_list/schedules_list.dart';
import 'package:test_dart/widgets/alarms_list/alarms_list.dart';
import 'package:test_dart/models/schedule.dart';
import 'package:test_dart/models/alarm.dart';

extension TimeOfDayExtension on TimeOfDay {
  int compareTo(TimeOfDay other) {
    if (hour < other.hour) return -1;
    if (hour > other.hour) return 1;
    if (minute < other.minute) return -1;
    if (minute > other.minute) return 1;
    return 0;
  }
}


class Schedules extends StatefulWidget {
  const Schedules({super.key});

  @override
  State<Schedules> createState() {
    return _SchedulesState();
  }
}

class _SchedulesState extends State<Schedules> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final List<Schedule> _registeredSchedules = [
    Schedule(
      title: 'Meeting',
      date: DateTime.now(),
    ),
    Schedule(
      title: 'Cinema',
      date: DateTime.now(),
    ),
  ];


  final List<Schedule> _registeredAlarmsTemp = [
    
  ];

  final List<Alarm> _registeredAlarms = [];

  DateTime _selectedDate = DateTime.now();
  String _appBarTitle = "${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}";

  void _openAddScheduleOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewSchedule(currentDate: _selectedDate, onAddSchedule: _addSchedule),
    );
  }

  void _openAddAlarmTempOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewAlarmTemp(currentDate: _selectedDate, onAddSchedule: _addAlarmTemp),
    );
  }

  void _openAddAlarmOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewAlarm(onAddAlarm: _addAlarm),
    );
  }

  void _addSchedule(Schedule schedule) {
    setState(() {
      _registeredSchedules.add(schedule);
    });
  }

  void _addAlarmTemp(Schedule schedule) {
    setState(() {
      _registeredAlarmsTemp.add(schedule);
    });
  }

  void _addAlarm(Alarm alarm) {
    setState(() {
      _registeredAlarms.clear();
      _registeredAlarms.add(alarm);
    });
  }


  void _removeSchedule(Schedule schedule) {
    final scheduleIndex = _registeredSchedules.indexOf(schedule);
    setState(() {
      _registeredSchedules.remove(schedule);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Schedule deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredSchedules.insert(scheduleIndex, schedule);
            });
          },
        ),
      ),
    );
  }

  void _removeAlarm(Alarm alarm) {
    final alarmIndex = _registeredAlarms.indexOf(alarm);
    setState(() {
      _registeredAlarms.remove(alarm);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Alarm deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredAlarms.insert(alarmIndex, alarm);
            });
          },
        ),
      ),
    );
  }

  void _removeAlarmTemp(Schedule schedule) {
    final scheduleIndex = _registeredAlarmsTemp.indexOf(schedule);
    setState(() {
      _registeredAlarmsTemp.remove(schedule);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Schedule deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredAlarmsTemp.insert(scheduleIndex, schedule);
            });
          },
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _appBarTitle = "${picked.year}/${picked.month}/${picked.day}";
      });
    }
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {

    super.build(context);

    Widget mainContent = const Center(
      child: Text('No schedules found.'),
    );

    if (_registeredSchedules.isNotEmpty) {
      mainContent = SchedulesList(
        schedules: _registeredSchedules,
        onRemoveSchedule: _removeSchedule,
      );
    }

    Widget mainAlarm = const Center(
      child: Text('No alarms found.'),
    );

    if (_registeredAlarms.isNotEmpty) {
      mainAlarm = AlarmsList(
        alarms: _registeredAlarms,
        onRemoveAlarm: _removeAlarm,
        date: _selectedDate,
      );
    }
    _registeredSchedules.sort((a, b) => a.date.compareTo(b.date));
    // _registeredAlarms.sort((a, b) => a.date.compareTo(b.date));

   final selectedSchedules = _registeredSchedules
        .where((Schedule) =>
            isSameDay(Schedule.date, _selectedDate))
        .toList();

    final selectedAlarmsTemp = _registeredAlarmsTemp
        .where((alarm) =>
            isSameDay(alarm.date, _selectedDate))
        .toList();

    final selectedAlarms = _registeredAlarms
        .where((alarm) =>
            alarm.times[_selectedDate.weekday%7] != null)
        .toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => _selectDate(context),
          icon: const Icon(Icons.calendar_today),
        ),
        title: Text(_appBarTitle.isNotEmpty ? _appBarTitle : 'App bar'),/*Padding(
          padding: const EdgeInsets.all(8.0),
          child:*Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              //SizedBox(width: 40,),
              Text(_appBarTitle.isNotEmpty ? _appBarTitle : 'App bar'),
              Spacer(),
              WeatherGenerationService(),
            ],
          ),
        ),*///WeatherGenerationService(),
        /*actions: [
          IconButton(
            onPressed: () => _selectDate(context),
            icon: Icon(Icons.calendar_today),
          ),
        ],*/
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              const SizedBox(width: 30),
              const Text('Alarm'),
              Tooltip(
                message: 'Set your weekly alarms over here',
                child: IconButton(
                  onPressed: _openAddAlarmOverlay,
                  icon: const Icon(Icons.settings),
                ),
              ),
              Tooltip(
                message: 'Modify your temparay alarm over here',
                child: IconButton(
                  onPressed: _openAddAlarmTempOverlay,
                  icon: const Icon(Icons.add),
                ),
              ),
            ],
          ),  
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15, // Set max height for mainAlarm
            child: selectedAlarmsTemp.isNotEmpty
                ? SchedulesList(
                    schedules: selectedAlarmsTemp,
                    onRemoveSchedule: _removeAlarmTemp,
                  )
                :selectedAlarms.isNotEmpty
                ? AlarmsList(
                    alarms: selectedAlarms,
                    onRemoveAlarm: _removeAlarm,
                    date: _selectedDate,
                  )
                : const Center(
                    child: Text('No alarms found.'),
                  ),
          ),
          Row(
            children: [
              const SizedBox(width: 30),
              const Text("Today's schedules"),
              IconButton(
                onPressed: _openAddScheduleOverlay,
                icon: const Icon(Icons.add),
              ),
            ],
          ),  
          Expanded(
            child: selectedSchedules.isNotEmpty
                ? SchedulesList(
                    schedules: selectedSchedules,
                    onRemoveSchedule: _removeSchedule,
                  )
                : const Center(
                    child: Text('No schedules found for selected date.'),
                  ),
          ),
        ],
      ),
      
    );
  }
}
