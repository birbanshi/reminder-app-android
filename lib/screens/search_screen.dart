import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'package:to_do_app/models/reminder.dart';
import 'package:to_do_app/utils/helper.dart';

class SearchScreen extends StatefulWidget {
  final List<Reminder> searchList;
  const SearchScreen({Key? key, required this.searchList}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FocusNode _focus = FocusNode();
  bool showTrailingIcon = false;
  TextEditingController searchController = TextEditingController();
  bool yesIsSelected = false;
  bool noIsSelected = false;
  bool todayIsSelected = false;
  bool tomorrowIsSelected = false;
  List<Reminder> searchResult = <Reminder>[];

  void _focusListener() {
    if (_focus.hasFocus) {
      setState(() {
        showTrailingIcon = true;
      });
    } else {
      setState(() {
        showTrailingIcon = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _focus.addListener(_focusListener);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      // color: Colors.grey[350],
                    ),
                    child: ListTile(
                      leading: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back)),
                      title: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                            hintText: "Search your reminders",
                            border: InputBorder.none),
                        onEditingComplete: () {},
                        onChanged: (value) {
                          searchResult.clear();
                          for (Reminder items in widget.searchList) {
                            if (items.title.contains(searchController.text) ||
                                (items.description as String)
                                    .contains(searchController.text)) {
                              setState(() {
                                searchResult.add(items);
                              });
                              developer.log(items.toString());
                            }
                          }
                        },
                        focusNode: _focus,
                      ),
                      trailing: showTrailingIcon
                          ? IconButton(
                              onPressed: () {
                                searchController.clear();
                                setState(() {
                                  searchResult.clear();
                                });
                              },
                              icon: const Icon(Icons.clear_all),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Pinned",
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      ChoiceChip(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          label: const Text(
                            "Yes",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 20,
                            ),
                          ),
                          selected: yesIsSelected,
                          onSelected: (value) {
                            setState(() {
                              yesIsSelected = value;
                              if (noIsSelected) {
                                noIsSelected = !value;
                              }
                            });
                          }),
                      const SizedBox(
                        width: 16,
                      ),
                      ChoiceChip(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        label: const Text(
                          "No",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                          ),
                        ),
                        selected: noIsSelected,
                        onSelected: (value) {
                          setState(() {
                            noIsSelected = value;
                            if (yesIsSelected) {
                              yesIsSelected = !value;
                            }
                            // yesIsSelected = !value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Reminder Scheduled",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      ChoiceChip(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        label: const Text(
                          "Today",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        selected: todayIsSelected,
                        onSelected: (value) {
                          setState(() {
                            todayIsSelected = value;
                            if (tomorrowIsSelected) {
                              tomorrowIsSelected = !value;
                            }
                          });
                        },
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      ChoiceChip(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        label: const Text(
                          "Tomorrow",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        selected: tomorrowIsSelected,
                        onSelected: (value) {
                          setState(() {
                            tomorrowIsSelected = value;
                            if (todayIsSelected) {
                              todayIsSelected = !value;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  // Visibility(
                  //     visible: searchResult.isNotEmpty,
                  //     child: reminderCard(searchResult, context)),
                  // Container(
                  //   height: 300,
                  //   color: Colors.red,
                  // ),
                  // Container(
                  //   height: 600,
                  //   color: Colors.blue,
                  // ),
                  reminderCard(widget.searchList, context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
