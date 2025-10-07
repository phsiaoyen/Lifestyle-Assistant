import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

const uuid = Uuid();


class Schedule {
  Schedule({
    required this.title,
    required this.date,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final DateTime date;

  String get formattedDate {
    return formatter.format(date);
  }
}
