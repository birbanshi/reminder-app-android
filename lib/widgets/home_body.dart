import 'package:flutter/material.dart';
import 'package:to_do_app/models/reminder.dart';
import 'dart:developer' as developer;

import 'package:to_do_app/utils/helper.dart';

class HomeBody extends StatelessWidget {
  final List<Reminder> remList;
  const HomeBody({Key? key, required this.remList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 12,
          ),
          Visibility(
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: Text(
                "Pinned",
                // Move this into theme
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            visible: (returnPinnedList(remList).isNotEmpty),
          ),
          reminderCard(returnPinnedList(remList), context, localizations),
          Visibility(
            child: const SizedBox(
              height: 12,
            ),
            visible: (returnPinnedList(remList).isNotEmpty),
          ),
          Visibility(
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: Text(
                "Upcoming",
                // TODO move into theme
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            visible: (upcomingReminderList(remList).isNotEmpty),
          ),
          reminderCard(upcomingReminderList(remList), context, localizations),
        ],
      ),
    );
  }
}
