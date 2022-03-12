import 'dart:io';
import 'dart:developer' as developer;

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:to_do_app/models/reminder.dart';

class DatabaseProvider {
  static final DatabaseProvider instance = DatabaseProvider._instance();
  static Database? _database;
  static const _dbName = "reminder_database.db";
  static const _dbVersion = 1;

  DatabaseProvider._instance();

  Future<Database> get database async {
    if (_database != null) {
      // Log output
      developer.log("Database $_dbName has been created",
          name: "database_provider.dart", level: 800);
      return _database!;
    } else {
      _database = await _initDB();
    }
    // Log output
    developer.log("Database $_dbName has been created",
        name: "DatabaseProvider", level: 800);
    return _database!;
  }

  Future<Database> _initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    // Log output
    developer.log("DB location => $path",
        name: "database_provider.dart", level: 500);
    return await openDatabase(path, version: _dbVersion, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    db.execute('''
        CREATE TABLE $tableName (
          ${ReminderFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${ReminderFields.titleColumn} TEXT NOT NULL,
          ${ReminderFields.descriptionColumn} TEXT,
          ${ReminderFields.pinnedColumn} BOOLEAN NOT NULL,
          ${ReminderFields.notifyColumn} BOOLEAN NOT NULL,
          ${ReminderFields.dateColumn} TEXT NOT NULL,
          ${ReminderFields.timeColumn} TEXT NOT NULL,
          ${ReminderFields.color} INTEGER NOT NULL
        )
      ''');
    developer.log("Table $tableName has been created",
        name: "database_provider.dart", level: 800);
  }

  Future closeDB() async {
    final db = await instance.database;
    db.close();
    // Log output
    developer.log("$_dbName closed",
        name: "database_provider.dart", level: 500);
  }

  Future<Reminder> createReminder({required Reminder reminder}) async {
    final db = await instance.database;
    final id = await db.insert(tableName, reminder.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    // Log output
    developer.log("$reminder added to $_dbName",
        name: "database_provider.dart", level: 500);
    return reminder.copy(id: id);
  }

  Future<List<Reminder>> readAll() async {
    final db = await instance.database;
    final data = await db.query(tableName,
        groupBy: ReminderFields.timeColumn, orderBy: ReminderFields.dateColumn);
    final retVal =
        data.map((item) => Reminder.toReminder(jsonData: item)).toList();

    developer.log(
        "Retured type => ${retVal.runtimeType.toString()} from readAll()",
        level: 500,
        name: "database_provider.dart");
    return retVal;
  }

  Future<int> updateReminder(Reminder reminder) async {
    final db = await instance.database;
    // developer.log(
    //     "runtimetype => title: ${reminder.title.runtimeType}, description: ${reminder.description.runtimeType}, isPinned: ${reminder.isPinned.runtimeType}, notify: ${reminder.notify.runtimeType}, color: ${reminder.color.runtimeType}, date: ${reminder.date.runtimeType}, time: ${reminder.time.runtimeType}, id: ${reminder.id.runtimeType}");
    final retVal = await db.update(tableName, reminder.toJson(),
        where: "${ReminderFields.id} = ?",
        whereArgs: [reminder.id],
        conflictAlgorithm: ConflictAlgorithm.ignore);
    developer.log("$reminder.id updated. $retVal changes made.",
        level: 500, name: "database_provider.dart");
    return retVal;
  }

  Future<int> deleteReminder(Reminder reminder) async {
    final db = await instance.database;
    final retVal = db.delete(tableName,
        where: "${ReminderFields.id} = ?", whereArgs: [reminder.id]);
    developer.log("$retVal row deleted");
    return retVal;
  }

  Future<List<Reminder>> getPinnedReminder() async {
    final db = await instance.database;
    final data = await db.query(tableName,
        where: "${ReminderFields.notifyColumn} = ?", whereArgs: [1]);
    final retVal = data
        .map((reminder) => Reminder.toReminder(jsonData: reminder))
        .toList();
    developer.log('''Returned from getPinnedReminder =>
                                          ${retVal.map((e) => e.toString())}
                  ''', name: "database_provider.dart", level: 500);
    return retVal;
  }
}
