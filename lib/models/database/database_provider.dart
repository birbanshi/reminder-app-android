import 'dart:io';
import 'dart:developer' as developer;

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:to_do_app/models/reminder.dart';

class DatabaseProvider {
  final Type _type = DatabaseProvider;
  static final DatabaseProvider instance = DatabaseProvider._instance();
  static Database? _database;
  static const _dbName = "reminder_database.db";
  static const _dbVersion = 1;

  DatabaseProvider._instance();

  Future<Database> get database async {
    if (_database != null) {
      // Log output
      developer.log("Database $_dbName has been created",
          name: _type.toString(), level: 800);
      return _database!;
    } else {
      _database = await _initDB();
    }
    // Log output
    developer.log("Database $_dbName has been created",
        name: _type.toString(), level: 800);
    return _database!;
  }

  Future<Database> _initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    // Log output
    developer.log("_initDB() => Database location $path",
        name: _type.toString(), level: 500);
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
          ${ReminderFields.reminderDateTimeColumn} TEXT NOT NULL,
          ${ReminderFields.color} INTEGER NOT NULL
        )
      ''');
    developer.log("_createDB() => Table $tableName has been created",
        name: _type.toString(), level: 800);
  }

  Future closeDB() async {
    final db = await instance.database;
    db.close();
    // Log output
    developer.log("closeDB() => $_dbName has been closed",
        name: _type.toString(), level: 500);
  }

  Future<Reminder> createReminder({required Reminder reminder}) async {
    final db = await instance.database;
    final id = await db.insert(tableName, reminder.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    // Log output
    developer.log("createReminder() => $reminder added to $_dbName",
        name: _type.toString(), level: 500);
    return reminder.copy(id: id);
  }

  Future<List<Reminder>> readAll() async {
    final db = await instance.database;
    final data = await db.query(tableName,
        orderBy: ReminderFields.reminderDateTimeColumn);
    final retVal =
        data.map((item) => Reminder.toReminder(jsonData: item)).toList();

    developer.log(
        "readAll() => ${retVal.runtimeType.toString()} with length ${retVal.length}",
        level: 500,
        name: _type.toString());
    return retVal;
  }

  Future<int> updateReminder(Reminder reminder) async {
    final db = await instance.database;
    final retVal = await db.update(tableName, reminder.toJson(),
        where: "${ReminderFields.id} = ?",
        whereArgs: [reminder.id],
        conflictAlgorithm: ConflictAlgorithm.ignore);
    developer.log(
        "updateReminder() => ${reminder.id} updated. $retVal changes made.",
        level: 500,
        name: _type.toString());
    return retVal;
  }

  Future<int> deleteReminder(Reminder reminder) async {
    final db = await instance.database;
    final retVal = db.delete(tableName,
        where: "${ReminderFields.id} = ?", whereArgs: [reminder.id]);
    developer.log("deleteReminder() => ${reminder.id} has been deleted",
        level: 500, name: _type.toString());
    return retVal;
  }

  Future<List<Reminder>> getPinnedReminder() async {
    final db = await instance.database;
    final data = await db.query(tableName,
        where: "${ReminderFields.pinnedColumn} = ?", whereArgs: [1]);
    final retVal = data
        .map((reminder) => Reminder.toReminder(jsonData: reminder))
        .toList();
    developer.log("getPinnedReminder() => No of pinned items ${retVal.length}",
        level: 500, name: _type.toString());
    return retVal;
  }

  Future<List<Reminder>> getUpcomingReminder() async {
    final db = await instance.database;
    final data = await db.query(tableName,
        where: "${ReminderFields.pinnedColumn} = ?", whereArgs: [0]);
    final retVal = data.map((e) => Reminder.toReminder(jsonData: e)).toList();
    developer.log(
        "getUpcomingReminder() => No of upcoming items ${retVal.length}",
        level: 500,
        name: _type.toString());
    return retVal;
  }
}
