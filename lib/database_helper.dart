import 'package:database_project/user_model.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _databaseHelper = DatabaseHelper._();

  DatabaseHelper._();

  Database? db;

  factory DatabaseHelper() {
    return _databaseHelper;
  }

  Future<void> initDB() async {
    String path = await getDatabasesPath();
    debugPrint("path---->$path");
    db = await openDatabase(
      join(path, 'stu.db'),
      onCreate: (database, version) async {
        await database.execute(
          """
            CREATE TABLE demo (
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              name TEXT NOT NULL ,
              age INTEGER NOT NULL, 
              email TEXT NOT NULL UNIQUE
              
            )
          """,
        );
        debugPrint("table--------------->>$db");
        debugPrint("table--------------created");
      },
      version: 1,
    );
  }

  Future<void> insertUser(User user) async {
    int result = await db!.insert('demo', user.toMap());
    result;
    debugPrint("reult----------------->>$result");
  }

  // Future<int> insertUser(User user) async {
  //   int result = await db!.insert('demo', user.toMap());
  //    return   result;
  // }

  Future<int> updateUser(User user) async {
    int result = await db!.update(
      'demo',
      user.toMap(),
      where: "id = ?",
      whereArgs: [user.id],
    );
    return result;
  }

  Future<List<User>> retrieveUsers() async {
    final List<Map<String, Object?>> queryResult = await db!.query('demo');
    debugPrint("queryResult----------------->>$queryResult");

    return queryResult.map((e) => User.fromMap(e)).toList();
  }

  Future<bool> checkEmailExist(String email) async {
    final List<Map<String, Object?>> queryResult = await db!.query('demo');
    // debugPrint("queryResult----------------->>$queryResult");

    for (var items in queryResult) {
      // debugPrint("Loop----------------->>$items");
      // debugPrint("------------------->>${items['email'].toString()}");
      if (items['email'].toString() == email) {
        debugPrint("true email  ------------------------>>${items['email'].toString()}");
        // return Future.value(true);
        return true;
      }
    }

    // return Future.value(false);
    return false;
  }

  Future<void> deleteUser(int id) async {
    await db!.delete(
      'demo',
      where: "id = ?",
      whereArgs: [id],
    );

    debugPrint("delete----------------->>${db!.delete}");
  }
}
