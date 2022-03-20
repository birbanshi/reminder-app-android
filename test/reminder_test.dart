import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_app/models/reminder.dart';

void main() {
  group("Testing reminder class", () {
    test("Test 1 => toJson() works", () {
      Reminder rem = Reminder(
          id: 9,
          title: "Test title",
          isPinned: true,
          notify: true,
          reminderDateTime: DateTime.now(),
          color: ReminderColor.reminderColors.elementAt(1),
          description: "Some test description");
      final retVal = rem.toJson();
      expect(retVal, isA<Map<String, dynamic>>());
      expect(retVal["title"], "Test title");
      expect(retVal["isPinned"], 1);
      expect(retVal["reminderDateTime"].runtimeType, String);
      expect(retVal["description"], "Some test description");
      expect(retVal["_id"], 9);
    });
    test("Test 2 => toJson() works", () {
      Reminder rem = Reminder(
          title: "Test title",
          isPinned: false,
          notify: true,
          reminderDateTime: DateTime.now(),
          color: ReminderColor.reminderColors[0]);
      final retVal = rem.toJson();
      expect(retVal["description"], "");
      expect(retVal["_id"], null);
      expect(retVal["_id"], null);
    });
    test("Test 3 => toReminder() works", () {
      Reminder rem = Reminder(
          id: 9,
          title: "Test title",
          isPinned: true,
          notify: true,
          reminderDateTime: DateTime.now(),
          color: ReminderColor.reminderColors[1],
          description: "Some test description");

      final retVal = Reminder.toReminder(jsonData: rem.toJson());
      expect(retVal.id, 9);
      expect(retVal.description.runtimeType, String);
      expect(retVal.isPinned, true);
      expect(retVal.reminderDateTime.runtimeType, DateTime);
      expect(retVal.color, Colors.indigo);
    });
    test("Test 4 => toReminder() works", () {
      Reminder rem = Reminder(
          id: 2,
          title: "Test title",
          isPinned: false,
          notify: true,
          reminderDateTime: DateTime.now(),
          color: ReminderColor.reminderColors[0]);
      final retVal = Reminder.toReminder(jsonData: rem.toJson());
      expect(retVal, isA<Reminder>());
      expect(retVal.id, 2);
      expect((retVal.description as String).length, 0);
      expect(retVal.isPinned, false);
      expect(retVal.reminderDateTime, isA<DateTime>());
      expect(retVal.color, Colors.white);
    });
    test("Test 5 => copy() works", () {
      Reminder rem = Reminder(
          title: "Test title",
          isPinned: false,
          notify: true,
          reminderDateTime: DateTime.now(),
          color: ReminderColor.reminderColors[0]);
      rem = rem.copy(id: 9);
      expect(rem.id, 9);
    });
    test("Test 6 => toString() works", () {
      Reminder rem = Reminder(
          id: 2,
          title: "Test title",
          isPinned: false,
          notify: true,
          reminderDateTime: DateTime.now(),
          color: ReminderColor.reminderColors[0]);
      final retVal = rem.toString();
      expect(retVal.toString().runtimeType, String);
    });
  });
}
