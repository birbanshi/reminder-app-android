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
          ${ReminderFields.timeColumn} TEXT NOT NULL
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
        name: "DatabaseProvider", level: 500);
    return reminder.copy(id: id);
  }

  Future<List<Reminder>> readAll() async {
    final db = await instance.database;
    final data = await db.query(tableName);
    final retVal =
        data.map((item) => Reminder.toReminder(jsonData: item)).toList();

    developer.log(
        "Retured type => ${retVal.runtimeType.toString()} from readAll()",
        level: 500,
        name: "database_provider.dart");
    return retVal;
  }

  // Future readReminder() async {}
}
