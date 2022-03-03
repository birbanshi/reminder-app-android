import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

class PopUp extends StatelessWidget {
  const PopUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("When to remind?"),
      content: Wrap(
        children: [
          Column(
            children: [
              DateTimePicker(
                type: DateTimePickerType.date,
                firstDate: DateTime.now(),
                lastDate: DateTime(2030),
                icon: const Icon(Icons.event),
                dateHintText: "Today",
              ),
              DateTimePicker(
                type: DateTimePickerType.time,
                timeHintText: "After 5 Mins.",
                initialTime: TimeOfDay.now(),
                icon: const Icon(Icons.alarm),
                // use24HourFormat: false,
                // locale: const Locale('en'),
              )
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
