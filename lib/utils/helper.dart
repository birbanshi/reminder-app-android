import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/utils/custom_scroll_behavior.dart';
import 'dart:developer' as developer;

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

Widget reminderCard(List<Reminder> rem, BuildContext context,
    MaterialLocalizations localizations) {
  return ScrollConfiguration(
    behavior: CustomScrollBehavior(),
    child: MasonryGridView.count(
      shrinkWrap: true,
      reverse: false,
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 6,
      ),
      itemCount: rem.length,
      crossAxisCount: 2,
      mainAxisSpacing: 4,
      crossAxisSpacing: 6,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: (() {
            developer.log("$index tapped");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => AddReminder(
                  rem: rem[index],
                ),
              ),
            );
          }),
          child: Card(
            color: rem[index].color,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12, top: 6),
              child: Column(
                children: [
                  ListTile(
                    title: Text(rem[index].title),
                    subtitle: Visibility(
                      visible: (rem[index].description as String).isEmpty
                          ? false
                          : true,
                      child: Text(rem[index].description as String),
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            prettyDateFormat(rem[index].date),
                            Text(
                              localizations.formatTimeOfDay(rem[index].time),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
