import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

Widget showLoading({required bool isVisible}) {
  return Visibility(
    child: Center(
      child: Container(
        padding: const EdgeInsets.all(18),
        height: 80,
        width: 80,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 2,
              blurRadius: 4,
            ),
          ],
        ),
        child: const CircularProgressIndicator(),
      ),
    ),
    visible: isVisible,
  );
}

Widget prettyDateFormat(DateTime date) {
  if (date.day == DateTime.now().day) {
    return const Text("Today ");
  } else if (date.day == (DateTime.now().day + 1)) {
    return const Text("Tomorrow ");
  } else {
    return Text(DateFormat("d MMMM ").format(date));
  }
}
