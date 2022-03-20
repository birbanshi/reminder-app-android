import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/models/database/database_provider.dart';
import 'package:to_do_app/models/reminder.dart';
import 'dart:developer' as developer;

import 'package:to_do_app/utils/helper.dart';

// Extension class that adds a new method add to TimeOfDay
extension TimeOfDayExtension on TimeOfDay {
  TimeOfDay add({int hour = 0}) {
    final retHour = TimeOfDay.now().hour + hour;
    if (retHour > 23) {
      return replacing(hour: 0);
    }
    return replacing(hour: retHour);
  }
}

class PopUp extends StatefulWidget {
  final String title;
  final String? description;
  final bool isPinned;
  final Color color;
  final bool notificationStatus;
  final DateTime? remDate;
  final TimeOfDay? remTime;
  final int? id;
  const PopUp(
      {Key? key,
      required this.title,
      this.description,
      required this.isPinned,
      required this.color,
      required this.notificationStatus,
      this.remDate,
      this.remTime,
      this.id})
      : super(key: key);

  @override
  State<PopUp> createState() => _PopUpState();
}

class _PopUpState extends State<PopUp> {
  // Default value of time, i.e. time after an hour
  late TimeOfDay time;
  // Default value of date, i.e. today
  late DateTime date;
  // If true this changes date text from today to the date selected
  late bool changeDateText;
  // If true this changes time text from "After 1 hour" to the time selected
  late bool changeTimeText;

  @override
  void initState() {
    super.initState();
    time = (widget.remTime != null)
        ? widget.remTime as TimeOfDay
        : TimeOfDay.now().add(hour: 1);
    date =
        (widget.remDate != null) ? widget.remDate as DateTime : DateTime.now();
    changeDateText = (widget.remDate != null) ? true : false;
    changeTimeText = (widget.remTime != null) ? true : false;
  }

  void insertDataIntoDatabase(
      {required String title,
      required String? description,
      required bool pinned,
      required bool notify,
      required Color color}) async {
    Reminder reminder = Reminder(
        title: title,
        isPinned: pinned,
        notify: notify,
        reminderDateTime: convertToDateTime(date, time),
        description: description,
        color: color);
    DatabaseProvider.instance.createReminder(reminder: reminder);
  }

  void showCustomTimePickerDialog() async {
    final TimeOfDay? dialog = await showTimePicker(
      context: context,
      initialTime: time,
      initialEntryMode: TimePickerEntryMode.dial,
      helpText: "When to remind?",
    );
    if (dialog != null) {
      setState(() {
        // Changes the time text and sets the
        //time to the value selected by the user
        changeTimeText = true;
        time = dialog;
      });
    }
  }

  void showCustomDatePickerDialog() async {
    final DateTime? dialog = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: date.isBefore(DateTime.now()) ? date : DateTime.now(),
      lastDate: DateTime(2030),
      helpText: "When to remind?",
    );
    if (dialog != null) {
      setState(() {
        // Changes the date text and sets the date
        // to the value selected by the user
        date = dialog;
        changeDateText = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("When to remind?"),
      content: Wrap(
        children: [
          Column(
            children: [
              InkWell(
                // !changeDateText
                //       ? const Text("Today")
                //       : Text(DateFormat("yyyy-MM-dd").format(date))
                child: ListTile(
                  title: (!changeDateText)
                      ? const Text("Today")
                      : (changeDateText && (date.day == DateTime.now().day))
                          ? const Text("Today")
                          : (changeDateText &&
                                  (date.day == (DateTime.now().day + 1)))
                              ? const Text("Tomorrow")
                              : Text(DateFormat("yyyy-MM-dd").format(date)),
                  trailing: const Icon(Icons.date_range),
                ),
                onTap: showCustomDatePickerDialog,
              ),
              InkWell(
                child: ListTile(
                  title: !changeTimeText
                      ? const Text("After 1 hour")
                      : Text(time.format(context)),
                  trailing: const Icon(Icons.access_time),
                ),
                onTap: showCustomTimePickerDialog,
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            if (widget.id != null) {
              developer.log("description => ${widget.description}");
              developer.log("id => ${widget.id}");
              DatabaseProvider.instance.updateReminder(
                Reminder(
                    id: widget.id,
                    title: widget.title,
                    description: widget.description as String,
                    isPinned: widget.isPinned,
                    notify: widget.notificationStatus,
                    reminderDateTime: convertToDateTime(date, time),
                    color: widget.color),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Successfully updated \"${widget.title}\""),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              insertDataIntoDatabase(
                  title: widget.title,
                  description: widget.description,
                  pinned: widget.isPinned,
                  notify: widget.notificationStatus,
                  color: widget.color);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Successfully added \"${widget.title}\""),
                  backgroundColor: Colors.green,
                ),
              );
            }
            // developer.log(widget.color.toString());
            Navigator.pushNamedAndRemoveUntil(
                context, "/home", (route) => false);
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
