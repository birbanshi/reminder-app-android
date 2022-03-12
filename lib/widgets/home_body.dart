import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:to_do_app/models/reminder.dart';
import 'package:to_do_app/screens/add_reminder.dart';
import 'dart:developer' as developer;

import 'package:to_do_app/utils/helper.dart';

class HomeBody extends StatelessWidget {
  final List<Reminder> remList;
  const HomeBody({Key? key, required this.remList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);

    return MasonryGridView.count(
      reverse: false,
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 6,
      ),
      itemCount: remList.length,
      crossAxisCount: 2,
      mainAxisSpacing: 4,
      crossAxisSpacing: 6,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: (() {
            developer.log("$index tapped");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => AddReminder(
                          rem: remList[index],
                        )));
          }),
          child: Card(
            color: remList[index].color,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12, top: 6),
              child: Column(
                children: [
                  ListTile(
                    title: Text(remList[index].title),
                    subtitle: Visibility(
                      visible: (remList[index].description as String).isEmpty
                          ? false
                          : true,
                      child: Text(remList[index].description as String),
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            prettyDateFormat(remList[index].date),
                            Text(
                              localizations
                                  .formatTimeOfDay(remList[index].time),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
