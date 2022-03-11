import 'package:flutter/material.dart';
import 'package:to_do_app/models/reminder.dart';
import 'package:to_do_app/widgets/pop_up.dart';
import 'dart:developer' as developer;

class AddReminder extends StatefulWidget {
  final Reminder? rem;
  const AddReminder({Key? key, this.rem}) : super(key: key);

  @override
  State<AddReminder> createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  late String reminderTitle;
  late String? reminderDescription;
  final _formKey = GlobalKey<FormState>();

  // Button colors
  List<MyButton> buttonList = <MyButton>[
    MyButton(index: 0, color: ReminderColor.reminderColors[0]),
    MyButton(index: 1, color: ReminderColor.reminderColors[1]),
    MyButton(index: 2, color: ReminderColor.reminderColors[2]),
    MyButton(index: 3, color: ReminderColor.reminderColors[3]),
    MyButton(index: 4, color: ReminderColor.reminderColors[4]),
    MyButton(index: 5, color: ReminderColor.reminderColors[5]),
  ];

  late int index;
  late Color backgroundColor;
  late bool isPinned;
  late bool notifyToggle;
  late bool validInput;

  @override
  void initState() {
    super.initState();
    isPinned = (widget.rem != null) ? widget.rem?.isPinned as bool : false;
    notifyToggle = (widget.rem != null) ? widget.rem?.notify as bool : false;
    index = (widget.rem != null)
        ? ReminderColor.reminderColors.indexOf(widget.rem?.color as Color)
        : 0;
    backgroundColor =
        (widget.rem != null) ? widget.rem?.color as Color : Colors.white;
    // developer.log("index => $index");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add ToDo"),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  // Changes button state
                  isPinned = !isPinned;
                });
              },
              icon: isPinned
                  ? const Icon(Icons.push_pin_rounded)
                  : const Icon(Icons.push_pin_outlined),
            ),
            IconButton(
              onPressed: () {
                // Changes button state
                setState(() {
                  // developer.log("initial notifyToggle => $notifyToggle");
                  notifyToggle = !notifyToggle;
                  // developer.log("final notifyToggle => $notifyToggle");
                });
                // developer.log("notifyToggle => $notifyToggle");
                // notifyToggle = notifyToggle;
              },
              icon: notifyToggle
                  ? const Icon(Icons.notification_add_rounded)
                  : const Icon(Icons.notification_add_outlined),
            ),
          ],
        ),
        body: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null) {
                        return "Field can't be empty.";
                      } else if (value.length < 11) {
                        return "Input must be longer than 10 characters.";
                      } else {
                        return null;
                      }
                    },
                    initialValue: widget.rem?.title,
                    onSaved: (value) {
                      developer.log(value as String);
                      reminderTitle =
                          (value != null) ? value : widget.rem?.title as String;
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "ToDo",
                    ),
                  ),
                  TextFormField(
                    initialValue: widget.rem?.description,
                    onSaved: (value) {
                      reminderDescription = value?.trim() as String;
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Description",
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            validInput = _formKey.currentState?.validate() as bool;
            if (validInput && widget.rem == null) {
              developer.log("validated");
              _formKey.currentState?.save();
              developer.log("saved...");
              showDialog(
                context: context,
                builder: (_) => PopUp(
                  title: reminderTitle,
                  description: reminderDescription,
                  isPinned: isPinned,
                  color: backgroundColor,
                  notificationStatus: notifyToggle,
                ),
              );
            } else if (validInput && widget.rem != null) {
              developer.log("validated");
              _formKey.currentState?.save();
              developer.log("saved");
              showDialog(
                context: context,
                builder: (_) => PopUp(
                  title: reminderTitle,
                  description: reminderDescription,
                  isPinned: isPinned,
                  color: backgroundColor,
                  notificationStatus: notifyToggle,
                  remDate: widget.rem?.date as DateTime,
                  remTime: widget.rem?.time as TimeOfDay,
                  id: widget.rem?.id as int,
                ),
              );
            }
          },
          child: const Icon(Icons.check),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        persistentFooterButtons: [
          Container(
            padding: const EdgeInsets.only(
              top: 32,
              bottom: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: buttonList
                  .map(
                    (MyButton btn) => InkWell(
                      child: Stack(
                        children: [
                          Container(
                            height: 45,
                            width: 45,
                            color: btn.color,
                          ),
                          Container(
                            child: Icon(
                              Icons.check,
                              size: 40,
                              color: (index == btn.index)
                                  ? Colors.grey[800]
                                  : btn.color,
                            ),
                            alignment: Alignment.center,
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          index = btn.index;
                          backgroundColor = btn.color;
                          // Log output
                          developer.log(
                              "Button ${btn.index + 1} is selected. Color => ${btn.color}",
                              name: "AddToDo",
                              level: 500);
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class MyButton {
  final int index;
  final Color color;
  MyButton({required this.index, required this.color});
}
