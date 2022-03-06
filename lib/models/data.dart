import 'package:to_do_app/models/to_do.dart';

class DataHandler {
  static List<ToDo> toDoList = <ToDo>[];
  DataHandler();
  void insert(ToDo toDo) {
    toDoList.add(toDo);
  }

  List<ToDo> getToDos() {
    return toDoList;
  }
}
