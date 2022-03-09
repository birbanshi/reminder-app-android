import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'package:to_do_app/utils/helper_methods.dart';

const String tableName = "reminder_table";

class ReminderFields {
  static final List<String> values = [
    id,
    titleColumn,
    descriptionColumn,
    pinnedColumn,
    notifyColumn,
    dateColumn,
    timeColumn
  ];

  static const String id = "_id";
  static const String titleColumn = "title";
  static const String descriptionColumn = "description";
  static const String pinnedColumn = "isPinned";
  static const String notifyColumn = "notify";
  static const String dateColumn = "date";
  static const String timeColumn = "time";
}

class Reminder {
  int? id;
  String title;
  String? description;
  bool isPinned;
  bool notify;
  DateTime date;
  TimeOfDay time;

  Reminder(
      {this.id,
      required this.title,
      this.description,
      required this.isPinned,
      required this.notify,
      required this.date,
      required this.time});

  Map<String, dynamic> toJson() {
    return {
      ReminderFields.id: id,
      ReminderFields.titleColumn: title,
      ReminderFields.descriptionColumn: description as String,
      ReminderFields.pinnedColumn: isPinned ? 1 : 0,
      ReminderFields.notifyColumn: notify ? 1 : 0,
      ReminderFields.dateColumn: date.toIso8601String(),
      ReminderFields.timeColumn: timeOfDayToString(time: time)
    };
  }

  static Reminder toReminder({required Map<String, Object?> jsonData}) {
    return Reminder(
        id: jsonData[ReminderFields.id] as int,
        title: jsonData[ReminderFields.titleColumn] as String,
        description: jsonData[ReminderFields.descriptionColumn] as String,
        isPinned: jsonData[ReminderFields.pinnedColumn] == 1,
        notify: jsonData[ReminderFields.notifyColumn] == 1,
        date: DateTime.parse(jsonData[ReminderFields.dateColumn] as String),
        time: stringToTimeOfDay(
            time: jsonData[ReminderFields.timeColumn] as String));
  }

  Reminder copy(
          {int? id,
          String? title,
          String? description,
          bool? isPinned,
          bool? notify,
          DateTime? date,
          TimeOfDay? time}) =>
      Reminder(
          id: id ?? this.id,
          title: title ?? this.title,
          description: description ?? this.description,
          isPinned: isPinned ?? this.isPinned,
          notify: notify ?? this.notify,
          date: date ?? this.date,
          time: time ?? this.time);

  String toString() {
    return '''
      ${ReminderFields.id} => $id,
      ${ReminderFields.timeColumn} => $title,
      ${ReminderFields.descriptionColumn} => $description,
      ${ReminderFields.pinnedColumn} => $isPinned,
      ${ReminderFields.notifyColumn} => $notify,
      ${ReminderFields.dateColumn} => ${date.toIso8601String()},
      ${ReminderFields.timeColumn} => ${timeOfDayToString(time: time)}
''';
  }
}
