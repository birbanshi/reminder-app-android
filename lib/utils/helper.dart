import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as developer;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../models/reminder.dart';
import '../screens/add_reminder.dart';

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

List<Reminder> returnPinnedList(List<Reminder> inputremList) {
  List<Reminder> pinnedList = <Reminder>[];
  for (final reminders in inputremList) {
    if (reminders.isPinned) {
      pinnedList.add(reminders);
    }
  }
  return pinnedList;
}

List<Reminder> upcomingReminderList(List<Reminder> inputremList) {
  List<Reminder> upcomingList = <Reminder>[];
  for (final reminders in inputremList) {
    if (!reminders.isPinned) {
      upcomingList.add(reminders);
    }
  }
  return upcomingList;
}

DateTime convertToDateTime(DateTime date, TimeOfDay time) {
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

Widget reminderCard(List<Reminder> remList, BuildContext context) {
  return Column(
    // crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Visibility(
        child: _gen(returnPinnedList(remList), "Pinned", context),
        visible: returnPinnedList(remList).isNotEmpty,
      ),
      Visibility(
        child: _gen(upcomingReminderList(remList), "Upcoming", context),
        visible: upcomingReminderList(remList).isNotEmpty,
      ),
    ],
  );
}

Widget _gen(List<Reminder> rem, String type, BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(
        height: 16,
      ),
      Text(type),
      MasonryGridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: rem.length,
          crossAxisCount: 2,
          itemBuilder: (context, index) {
            return _itemCard(rem[index], context);
          }),
    ],
  );
}

Widget _itemCard(Reminder reminder, BuildContext context) {
  return InkWell(
    onTap: (() {
      developer.log("${reminder.id} tapped");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => AddReminder(
            rem: reminder,
          ),
        ),
      );
    }),
    child: SizedBox(
      width: 200,
      child: Card(
        color: reminder.color,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12, top: 6),
          child: Column(
            children: [
              ListTile(
                title: Text(reminder.title),
                subtitle: Visibility(
                  visible:
                      (reminder.description as String).isEmpty ? false : true,
                  child: Text(reminder.description as String),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    DateFormat("E H:m").format(reminder.reminderDateTime),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
