import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';

import 'package:test_dart/widgets/welcome.dart';
import 'package:test_dart/widgets/color_schemes.blue.dart';

import 'dart:io';
import 'package:alarm/alarm.dart';
import 'dart:async';

var kColorScheme = lightColorSchemeBlue;
var kDarkColorScheme = darkColorSchemeBlue;


var robotnum=1;
var weightnow=55;
var idealweight=55;
var lackfood='fruit';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();
  runApp(
    MaterialApp(
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
        cardTheme: const CardTheme().copyWith(
          color: kDarkColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorScheme.primaryContainer,
            foregroundColor: kDarkColorScheme.onPrimaryContainer,
          ),
        ),
      ),
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.onPrimaryContainer,
          foregroundColor: kColorScheme.primaryContainer,
        ),
        cardTheme: const CardTheme().copyWith(
          color: kColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.primaryContainer,
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(
                fontWeight: FontWeight.bold,
                color: kColorScheme.onSecondaryContainer,
                fontSize: 16,
              ),
            ),
      ),
      // themeMode: ThemeMode.dark, // default
      home: const SplashScreen(duration: 2, goToPage: Welcome()),//const MyTabs(),
    ),
  );
}

class SplashScreen extends StatefulWidget {
  final int duration;
  final Widget goToPage;

  const SplashScreen({super.key, required this.duration, required this.goToPage});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _setAlarm();
    /*Future.delayed(Duration(seconds: widget.duration), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => widget.goToPage,
        ),
      );
    });*/
   _checkAlarmStatus(context) ;
  }

  void _checkAlarmStatus(context) async {
    Future.delayed(const Duration(seconds: 20), () async {
      bool ringing = await Alarm.isRinging(42);
      String a=ringing.toString();
      print(a);
      if (ringing) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => widget.goToPage,
          ),
        );
      }
    });
  }

  void _setAlarm() async {
    DateTime dateTime = DateTime.now().add(const Duration(seconds: 10)); 
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Row(
          children: [
            Center(
              child: Icon(
                Icons.accessibility_new_rounded,
                size: 60,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
             ElevatedButton(
              onPressed:() async{_setAlarm();},
              child: const Text("Sign in"),
            ),
          ],
        ),
      ),
    );
  }
}

