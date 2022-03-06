// import 'package:hive/hive.dart';

// part 'to_do.g.dart';

// @HiveType(typeId: 0)
// class ToDo extends HiveObject {
//   @HiveField(0)
//   late String toDoTitle;

//   @HiveField(1)
//   late String? toDoDescription;

//   @HiveField(2)
//   late bool pinned;

//   @HiveField(3)
//   late bool remind;
// }

import 'package:flutter/material.dart';

class ToDo {
  late String toDoTitle;
  late String? toDoDescription;
  late bool pinned;
  late bool notify;
  late DateTime date;
  late TimeOfDay time;
  late Color color;
}
