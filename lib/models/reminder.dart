import 'package:flutter/material.dart';
import 'dart:developer' as developer;

const String tableName = "reminder_table";

class ReminderFields {
  static final List<String> values = [
    id,
    titleColumn,
    descriptionColumn,
    pinnedColumn,
    notifyColumn,
    reminderDateTimeColumn,
    color
  ];

  static const String id = "_id";
  static const String titleColumn = "title";
  static const String descriptionColumn = "description";
  static const String pinnedColumn = "isPinned";
  static const String notifyColumn = "notify";
  static const String reminderDateTimeColumn = "reminderDateTime";
  static const String color = "color";
}

class Reminder {
  int? id;
  String title;
  String? description;
  bool isPinned;
  bool notify;
  DateTime reminderDateTime;
  Color color;

  Reminder(
      {this.id,
      required this.title,
      this.description,
      required this.isPinned,
      required this.notify,
      required this.reminderDateTime,
      required this.color});

  // Database provider takes input as Map
  Map<String, dynamic> toJson() {
    return {
      ReminderFields.id: id,
      ReminderFields.titleColumn: title,
      ReminderFields.descriptionColumn:
          description != null ? description as String : "",
      // Boolean is stored in sqflite as 0 or 1
      ReminderFields.pinnedColumn: isPinned ? 1 : 0,
      ReminderFields.notifyColumn: notify ? 1 : 0,
      ReminderFields.reminderDateTimeColumn: reminderDateTime.toIso8601String(),
      ReminderFields.color: ReminderColor.reminderColors.indexOf(color)
    };
  }

  // Output from DatabaseProvider.instance.readAll()
  // is returned as Map<String, Object?>
  static Reminder toReminder({required Map<String, Object?> jsonData}) {
    return Reminder(
        id: jsonData[ReminderFields.id] as int,
        title: jsonData[ReminderFields.titleColumn] as String,
        description: jsonData[ReminderFields.descriptionColumn] as String,
        // Boolean is stored in sqflite as 0 or 1
        isPinned: jsonData[ReminderFields.pinnedColumn] == 1,
        notify: jsonData[ReminderFields.notifyColumn] == 1,
        reminderDateTime: DateTime.parse(
            jsonData[ReminderFields.reminderDateTimeColumn] as String),
        color: ReminderColor.reminderColors
            .elementAt(jsonData[ReminderFields.color] as int));
  }

  Reminder copy(
          {int? id,
          String? title,
          String? description,
          bool? isPinned,
          bool? notify,
          DateTime? reminderDateTime,
          Color? color}) =>
      Reminder(
          id: id ?? this.id,
          title: title ?? this.title,
          description: description ?? this.description,
          isPinned: isPinned ?? this.isPinned,
          notify: notify ?? this.notify,
          reminderDateTime: reminderDateTime ?? this.reminderDateTime,
          color: color ?? this.color);

  @override
  String toString() {
    return '''
    {
      ${ReminderFields.id} => $id,
      ${ReminderFields.titleColumn} => $title,
      ${ReminderFields.descriptionColumn} => $description,
      ${ReminderFields.pinnedColumn} => $isPinned,
      ${ReminderFields.notifyColumn} => $notify,
      ${ReminderFields.reminderDateTimeColumn} => ${reminderDateTime.toIso8601String()},
      ${ReminderFields.color} => ${color.value}
    }
  ''';
  }
}

class ReminderColor {
  static List<Color> reminderColors = [
    Colors.white,
    Colors.indigo,
    Colors.yellowAccent,
    Colors.pinkAccent,
    Colors.greenAccent,
    Colors.purpleAccent,
  ];
}
