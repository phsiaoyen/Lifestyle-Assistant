import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'user.dart';
import 'package:test_dart/main.dart';
import 'package:test_dart/widgets/color_schemes.blue.dart';
import 'package:test_dart/widgets/color_schemes.red.dart';

import 'package:test_dart/widgets/alarm.dart';
import 'package:test_dart/widgets/foods.dart';
import 'dart:io';

import 'package:alarm/model/alarm_settings.dart';
import 'package:test_dart/models/schedule.dart';
import 'dart:async';

class SettingScreen extends StatefulWidget {
  final User user;

  const SettingScreen({Key? key, required this.user/*, required this.onDarkModeChanged*/}) : super(key: key);
  //final ValueChanged<bool> onDarkModeChanged;

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late TextEditingController _nameController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _goalController;
  late DateTime _selectedDate;
  final bool _darkMode = false;
  final Alarmwork _alarmwork=Alarmwork();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _heightController = TextEditingController(text: widget.user.height.toString());
    _weightController = TextEditingController(text: widget.user.weight.toString());
    _goalController = TextEditingController(text: widget.user.goal.toString());
    _selectedDate = widget.user.birthday ?? DateTime.now();
    _startCheckingAlarmStatus();
  }

    void _startCheckingAlarmStatus() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) async {
      bool isRinging = await _alarmwork.isAlarmRing();
      if(isRinging)
      {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Foods(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.grey, 
                  radius: 50,
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 25),
                Expanded(
                  child: TextFormField(
                    controller: _nameController,
                    maxLength: 30,
                    decoration: const InputDecoration(labelText: 'Name'),
                    onChanged: (value) {
                      setState(() {
                        widget.user.name = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _heightController,
                    maxLength: 10,
                    decoration: const InputDecoration(labelText: 'Height'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        widget.user.height = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 50),
                Expanded(
                  child: TextFormField(
                    controller: _weightController,
                    maxLength: 10,
                    decoration: const InputDecoration(labelText: 'Weight'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        widget.user.weight = double.tryParse(value) ?? 0.0;
                        weightnow = int.tryParse(value) ?? 0;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 50),
                Expanded(
                  child: TextFormField(
                    controller: _goalController,
                    maxLength: 10,
                    decoration: const InputDecoration(labelText: 'Goal Weight'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        widget.user.goal = double.tryParse(value) ?? 0.0;
                        idealweight = int.tryParse(value) ?? 0;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('AI Charater : '),
                Expanded(
                  child: DropdownButton<String>(
                    value: widget.user.aiCharacter,
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          widget.user.aiCharacter = value;
                          if(value=='Diet Expert')
                          {
                            robotnum=1;
                            kColorScheme = lightColorSchemeBlue;
                            kDarkColorScheme = darkColorSchemeBlue;
                          }
                          else if(value=='Angry Robot')
                          {
                            robotnum=2;
                            kColorScheme = lightColorSchemeRed;
                            kDarkColorScheme = darkColorSchemeRed;
                          }
                          else
                          {
                            robotnum=3;
                            kColorScheme = lightColorSchemeBlue;
                            kDarkColorScheme = darkColorSchemeBlue;
                          }
                        });
                      }
                    },
                    items: <String>['Diet Expert', 'Angry Robot', 'Cat']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 100),
                const Text('Birthday :'),
                IconButton(
                  onPressed: () => _selectDate(context),
                  icon: const Icon(
                    Icons.calendar_today,
                  ),
                ),
                Text(
                  DateFormat.yMd().format(_selectedDate),
                ),
              ],
            ),
            const SizedBox(height: 50),
            /*Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Dark Mode'),
                Switch(
                  value: _darkMode,
                  onChanged: (value) {
                    setState(() {
                      _darkMode = value;
                    });
                  },
                ),
              ],
            ),*/
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        widget.user.birthday = picked;
      });
    }
  }
}
