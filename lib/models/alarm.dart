import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

const uuid = Uuid();

class Alarm {
  Alarm({
    required this.title,
    required this.times,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final List<TimeOfDay?> times;
}