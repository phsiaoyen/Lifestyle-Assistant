//import 'dart:ffi';

import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_dart/models/schedule.dart';

import 'dart:io';
import 'package:alarm/alarm.dart';
import 'dart:async';
import 'package:test_dart/widgets/alarm.dart';
import 'package:test_dart/widgets/foods.dart';

final formatter = DateFormat.yMd().add_Hm();

class NewAlarmTemp extends StatefulWidget {
  const NewAlarmTemp({required this.currentDate, required this.onAddSchedule, super.key});

  final DateTime currentDate;
  final void Function(Schedule schedule) onAddSchedule;

  @override
  State<NewAlarmTemp> createState() {
    return _NewAlarmTempState();
  }
}

class _NewAlarmTempState extends State<NewAlarmTemp> {
  final _titleController = TextEditingController();
  DateTime? _selectedDate;
  DateTime? _current;

  GlobalKey titleKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _titleFocusNode = FocusNode();

  final Alarmwork _alarmwork=Alarmwork();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _current = widget.currentDate;

    _titleFocusNode.addListener(() {
      if (_titleFocusNode.hasFocus) {
        final RenderBox renderBox =
            titleKey.currentContext?.findRenderObject() as RenderBox;
        _scrollToRenderBox(renderBox);
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _scrollController.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  void _startCheckingAlarmStatus() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) async {
      bool isRinging = await _alarmwork.isAlarmRing();
      if(isRinging)
      {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Foods(),
          ),
        );
      }
    });
  }

  void _scrollToRenderBox(RenderBox renderBox) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final offset = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final bottomPosition = offset.dy + renderBox.size.height;
    final visibleScreenHeight = screenHeight - keyboardHeight;

    if (bottomPosition > visibleScreenHeight) {
      final scrollOffset = bottomPosition - visibleScreenHeight + 16;
      _scrollController.animateTo(
        _scrollController.offset + scrollOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _presentDatePicker() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime == null) {
      return;
    }
    setState(() {
      _selectedDate = DateTime(
        _current!.year,
        _current!.month,
        _current!.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  void _submitScheduleData() {
    if (_titleController.text.trim().isEmpty ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a valid title, date was entered.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }
    _alarmwork.setAlarm(_selectedDate!);
    widget.onAddSchedule(
      Schedule(
        title: _titleController.text,
        date: _selectedDate!,
      ),
    );
    Navigator.pop(context);
  }

  /*void _setAlarm() async {
    DateTime dateTime = _selectedDate!;
    final alarmSettings = AlarmSettings(
      id: 42,
      dateTime: dateTime,
      assetAudioPath: 'assets/alarm.mp3',
      loopAudio: true,
      vibrate: true,
      volume: 0.8,
      fadeDuration: 3.0,
      notificationTitle: 'This is the title',
      notificationBody: 'This is the body',
      enableNotificationOnKill: Platform.isIOS,
    );

    await Alarm.set(alarmSettings: alarmSettings);
  }*/

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(builder: (ctx, constraints) {

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 160, 16, keyboardSpace + 16),
            child: Column(
              children: [
                TextField(
                  key: titleKey,
                  controller: _titleController,
                  maxLength: 50,
                  focusNode: _titleFocusNode,
                  decoration: const InputDecoration(
                    label: Text('Temporary Alarm'),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _selectedDate == null
                                ? 'No time selected'
                                : formatter.format(_selectedDate!),
                          ),
                          IconButton(
                            onPressed: _presentDatePicker,
                            icon: const Icon(
                              Icons.schedule,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: _submitScheduleData,
                      child: const Text('Save Schedule'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
