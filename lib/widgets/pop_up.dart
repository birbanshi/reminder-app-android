import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension TimeOfDayExtension on TimeOfDay {
  TimeOfDay add({int hour = 0, int minute = 0}) {
    return replacing(hour: this.hour + hour, minute: this.minute + minute);
  }
}

class PopUp extends StatefulWidget {
  const PopUp({Key? key}) : super(key: key);

  @override
  State<PopUp> createState() => _PopUpState();
}

class _PopUpState extends State<PopUp> {
  TimeOfDay time = TimeOfDay.now().add(hour: 1);
  DateTime date = DateTime.now();
  bool changeDateText = false;
  bool changeTimeText = false;

  void showCustomTimePickerDialog() async {
    final TimeOfDay? dialog = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now().add(hour: 1),
      initialEntryMode: TimePickerEntryMode.dial,
      helpText: "When to remind?",
    );
    if (dialog != null) {
      setState(() {
        changeTimeText = true;
        time = dialog;
      });
    }
  }

  void showCustomDatePickerDialog() async {
    final DateTime? dialog = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      helpText: "When to remind?",
    );
    if (dialog != null) {
      setState(() {
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
            Navigator.pushNamedAndRemoveUntil(
                context, "/home", (route) => false);
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
