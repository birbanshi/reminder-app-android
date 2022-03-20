import 'package:flutter/material.dart';
import 'package:to_do_app/models/reminder.dart';
import 'dart:developer' as developer;

import 'package:to_do_app/utils/helper.dart';

class HomeBody extends StatelessWidget {
  final List<Reminder> remList;
  const HomeBody({Key? key, required this.remList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: reminderCard(remList, context),
    );
  }
}
