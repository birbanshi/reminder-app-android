import 'package:flutter/material.dart';
import 'package:to_do_app/widgets/pop_up.dart';

class AddToDo extends StatefulWidget {
  const AddToDo({Key? key}) : super(key: key);

  @override
  State<AddToDo> createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool isPinned = false;
  bool notifyToggle = false;

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
                  isPinned = !isPinned;
                });
              },
              icon: isPinned
                  ? const Icon(Icons.push_pin_rounded)
                  : const Icon(Icons.push_pin_outlined),
            ),
            IconButton(
              onPressed: () {
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
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "ToDo",
              ),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: "Description"),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            if (notifyToggle) {
              showDialog(
                context: context,
                builder: (_) => const PopUp(),
              );
            } else {
              Navigator.pushNamedAndRemoveUntil(
                  context, "/home", (route) => false);
            }
          },
          child: const Icon(Icons.check),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
