import 'package:flutter/material.dart';
import 'package:to_do_app/models/data.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    DataHandler handler = DataHandler();
    return MasonryGridView.count(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 6,
      ),
      itemCount: handler.getToDos().length,
      crossAxisCount: 2,
      mainAxisSpacing: 4,
      crossAxisSpacing: 6,
      itemBuilder: (context, index) {
        return Card(
          color: handler.getToDos()[index].color,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12, top: 6),
            child: Column(
              children: [
                ListTile(
                  title: Text(handler.getToDos()[index].toDoTitle),
                  subtitle:
                      Text(handler.getToDos()[index].toDoDescription as String),
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
                          Text(
                            DateFormat("d MMMM ")
                                .format(handler.getToDos()[index].date),
                          ),
                          Text(
                            localizations.formatTimeOfDay(
                                handler.getToDos()[index].time),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
