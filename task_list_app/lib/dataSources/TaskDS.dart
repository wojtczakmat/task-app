import 'dart:async';
import 'dart:io';

import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class TaskDataSource {
  static const String tableName = "Tasks";

  Database database;

  Future init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "tasks.db");

    database = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute(
            "CREATE TABLE $tableName (id NVARCHAR(40) PRIMARY KEY, title TEXT, desc TEXT)");
    });
  }

  Future<List<Task>> getAll() async {
    List<Task> tasks = new List<Task>();

    List<Map> taskMaps = await database.query(tableName, 
      columns: <String>["id", "title", "desc"]);
    
    for (var map in taskMaps) {
      Task task = new Task(map["title"], map["desc"]);
      task.id = map["id"];

      tasks.add(task);
    }

    return tasks;
  }

  Future<bool> add(Task task) async {
    try {
      await database.insert(
        tableName, 
        { 
          'id': task.id,
          'title': task.title,
          'desc': task.description
        }
      );

      return true;
    }
    catch (e) {
      return false;
    }
  }

  Future<bool> delete(Task task) async {
    try {
      var count = await database.delete(tableName, where: "id = ?", whereArgs: [task.id]);
      
      return count > 0;
    }
    catch (e) {
      return false;
    }
  }

  Future<bool> update(Task task) async {
    try {
      var count = await database.update(
        tableName,
        { 
          'title': task.title,
          'desc': task.description
        },
        where: "id = ?",
        whereArgs: [task.id]
      );

      return count > 0;
    }
    catch (e) {
      return false;
    }
  }
}