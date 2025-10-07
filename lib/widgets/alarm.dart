import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_dart/models/schedule.dart';

import 'dart:io';
import 'package:alarm/alarm.dart';
import 'dart:async';

final formatter = DateFormat.yMd().add_Hm();

/*class Alarmwork extends StatefulWidget {
  const Alarmwork({super.key});

  //final DateTime currentDate;
  //final void Function(Schedule schedule) onAddSchedule;
  @override
  State<Alarmwork> createState() {
    return _AlarmworkState();
  }
}*/

class Alarmwork {

  int setAlarmId=1;

  void setAlarm(DateTime dateTime) async {
    //DateTime dateTime = _selectedDate!;
    final alarmSettings = AlarmSettings(
      id: setAlarmId,
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
    setAlarmId=(setAlarmId+1)%100;
    await Alarm.set(alarmSettings: alarmSettings);

  }

  void stopAlarm() async{
    List<AlarmSettings> allAlarm=Alarm.getAlarms();
    for(int i=0;i<allAlarm.length;i++)
    {
      if(await Alarm.isRinging(allAlarm[i].id))
      {
        Alarm.stop(allAlarm[i].id);
      }
    }
  }

  Future<bool> isAlarmRing() async{
    List<AlarmSettings> allAlarm=Alarm.getAlarms();
    for(int i=0;i<allAlarm.length;i++)
    {
      if(await Alarm.isRinging(allAlarm[i].id))
      {
        return true;
      }
    }

    return false;
  } 
}
