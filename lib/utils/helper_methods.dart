// Helper functions
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'package:to_do_app/models/database/database_provider.dart';

import '../models/reminder.dart';

String timeOfDayToString({required TimeOfDay time}) {
  // TimeOfDay(20:34) is returned as "20:34"
  return time.toString().substring(10, 15);
}

TimeOfDay stringToTimeOfDay({required String time}) {
  // "20:34" is returned as TimeOfDay(20:34)
  List<String> _timeList = time.split(":");
  int hour = int.parse(_timeList.first);
  int minute = int.parse(_timeList.last);
  return TimeOfDay(hour: hour, minute: minute);
}
