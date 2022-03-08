import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/utils/helper_methods.dart';

// Extension class that adds a new method add to TimeOfDay
extension TimeOfDayExtension on TimeOfDay {
  TimeOfDay add({int hour = 0, int minute = 0}) {
    return replacing(hour: this.hour + hour, minute: this.minute + minute);
  }
}

class PopUp extends StatefulWidget {
  final String title;
  final String? description;
  final bool isPinned;
  final Color color;
  final bool notificationStatus;
  const PopUp(
      {Key? key,
      required this.title,
      this.description,
      required this.isPinned,
      required this.color,
      required this.notificationStatus})
      : super(key: key);

  @override
  State<PopUp> createState() => _PopUpState();
}

class _PopUpState extends State<PopUp> {
  // Default value of time, i.e. time after an hour
  TimeOfDay time = TimeOfDay.now().add(hour: 1);
  // Default value of date, i.e. today
  DateTime date = DateTime.now();
  // If true this changes date text from today to the date selected
  bool changeDateText = false;
  // If true this changes time text from "After 1 hour" to the time selected
  bool changeTimeText = false;

  // TODO modify this function to save data to sql database
  // Gets user input
  // void getUserInput(
  //     {required String title,
  //     required String? description,
  //     required bool pinned,
  //     required Color color}) {
  //   handler.insert(ToDo()
  //     ..toDoTitle = title
  //     ..toDoDescription = description
  //     ..notify = true
  //     ..date =
  //         DateFormat("yyyy-MM-dd").parse(DateFormat("yyyy-MM-dd").format(date))
  //     ..time = time
  //     ..pinned = pinned
  //     ..color = color);
  // }

  // TODO function to insert data in database
  void insertDataIntoDatabase(
      {required String title,
      required String? description,
      required bool pinned,
      required bool notify,
      required Color color}) async {
    // Database db = await DatabaseProvider.instance.database;
    // Map<String, dynamic> entry = {
    //   DatabaseProvider.titleColumn: title,
    //   DatabaseProvider.descriptionColumn: description,
    //   DatabaseProvider.pinnedColumn: pinned,
    //   DatabaseProvider.notifyColumn: notify,
    //   DatabaseProvider.color: color.toString(),
    //   DatabaseProvider.date: date.toString(),
    //   DatabaseProvider.time: time.toString()
    // };
    // DatabaseProvider.instance.insertIntooDatabase(entry);
    // debugPrint(DatabaseProvider.instance.insertIntooDatabase(entry).toString());

    // TODO try removing the try catch block
    // try {
    // debugPrint(await db.insert(DatabaseProvider.instance.tableName, entry)
    //     as String);
    // } on DatabaseException catch (e) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text(e.result.toString()),
    //     ),
    //   );
    // } catch (e) {
    //   // TODO fix the issue
    //   // ScaffoldMessenger.of(context).showSnackBar(
    //   //   SnackBar(
    //   //     content: Text(
    //   //       e.toString(),
    //   //     ),
    //   //   ),
    //   // );
    //   rethrow;
    // }
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
        // Changes the time text and sets the time to the value selected by the user
        changeTimeText = true;
        time = dialog;
      });
    }
  }

  void showCustomDatePickerDialog() async {
    final DateTime? dialog = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: date,
      lastDate: DateTime(2030),
      helpText: "When to remind?",
    );
    if (dialog != null) {
      setState(() {
        // Changes the date text and sets the date to the value selected by the user
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
                child: ListTile(
                  title: !changeDateText
                      ? const Text("Today")
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
            insertDataIntoDatabase(
                title: widget.title,
                description: widget.description,
                pinned: widget.isPinned,
                notify: widget.notificationStatus,
                color: widget.color);
            Navigator.pushNamedAndRemoveUntil(
                context, "/home", (route) => false);
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
