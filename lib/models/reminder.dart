import 'package:flutter/material.dart';

class Reminder {
  String title;
  String? description;
  bool isPinned;
  bool notify;
  DateTime date;
  TimeOfDay time;

  Reminder(
      {required this.title,
      this.description,
      required this.isPinned,
      required this.notify,
      required this.date,
      required this.time});
}
