import 'package:flutter/material.dart';
import 'package:to_do_app/widgets/pop_up.dart';
import 'dart:developer' as developer;

class AddToDo extends StatefulWidget {
  const AddToDo({Key? key}) : super(key: key);

  @override
  State<AddToDo> createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool showErrorText = false;
  // bool validate = false;
  bool isPinned = false;
  bool notifyToggle = false;

  // Button colors
  List<MyButton> buttonList = <MyButton>[
    MyButton(index: 0, color: Colors.white),
    MyButton(index: 1, color: Colors.amber),
    MyButton(index: 2, color: Colors.indigo),
    MyButton(index: 3, color: Colors.purple),
    MyButton(index: 4, color: Colors.pink),
    MyButton(index: 5, color: Colors.teal),
  ];
  // Default index
  int index = 0;
  Color backgroundColor = Colors.white;

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
                  notifyToggle = !notifyToggle;
                });
              },
              icon: notifyToggle
                  ? const Icon(Icons.notification_add_rounded)
                  : const Icon(Icons.notification_add_outlined),
            ),
          ],
        ),
        body: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "ToDo",
                errorText: showErrorText ? "Field can't be empty" : null,
              ),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Description",
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            setState(() {
              _titleController.text.trim().isEmpty
                  ? showErrorText = true
                  : showErrorText = false;
            });
            if (!showErrorText) {
              developer.log(_descriptionController.text.trim());
              showDialog(
                context: context,
                builder: (_) => PopUp(
                  title: _titleController.text.trim(),
                  description: _descriptionController.text.trim(),
                  isPinned: isPinned,
                  color: backgroundColor,
                  notificationStatus: notifyToggle,
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
