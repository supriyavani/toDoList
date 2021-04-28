import 'dart:io';

import 'package:flutter_application_2/models/todomodel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  String tableName = "to_do_list";
  String id = "id";
  String title = "title";
  String description = "description";
  String status = "status";
  String date = "date";
  static DatabaseHelper _databaseHelper;
  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }
  Database _database;
  get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "my_todolist.db";
    return await openDatabase(path, version: 2, onCreate: _create);
  }

  _create(Database _database, int version) async {
    return await _database.execute(
        "CREATE TABLE $tableName($id INTEGER PRIMARY KEY AUTOINCREMENT,$title TEXT,$description TEXT,$status TEXT,$date TEXT)");
  }

  Future<int> insert(ToDoModel toDoModel) async {
    Database database = await this.database;
    var results = database.insert(tableName, toDoModel.toMap());
    return results;
  }

  Future<List<Map<String, dynamic>>> getData() async {
    Database database = await this.database;
    return database.query(tableName);
  }

  Future<List<ToDoModel>> getPojo() async {
    List<Map<String, dynamic>> mapList = await getData();
    List<ToDoModel> toDoModelList = [];
    for (int i = 0; i < mapList.length; i++) {
      toDoModelList.add(ToDoModel.fromMap(mapList[i]));
    }
    return toDoModelList;
  }

  Future<int>update(ToDoModel toDoModel) async {
    Database database = await this.database;
    return database.update(tableName, toDoModel.toMap(),
        where: "$id =?", whereArgs: [toDoModel.id]);
  }
  Future<int>delete(ToDoModel toDoModel) async {
    Database database = await this.database;
    return database.delete(tableName,where: "$id =?", whereArgs: [toDoModel.id]);
  }
}
