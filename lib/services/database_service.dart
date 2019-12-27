import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {

  Future<Database> database;

  DatabaseService() {
    this.initDb();
  }

  void initDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'weasytoon_database.db');

    this.database = openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE animations(id INTEGER PRIMARY KEY, data TEXT)",
        );
      },
      version: 1,
    );

    // final Database db = await database;
    // await db.rawDelete('DELETE FROM animations');
  }

  void insert(table, model) async {
    final Database db = await database;

    var id = await db.insert(
      table,
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    model.id = id;

    print("Saved ${table} ${model.id}.");
  }

  Future<List<Map<String, dynamic>>> select(table) async {
    if (this.database == null) {
      await this.initDb();
    }

    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query(table);

    return maps;
  }

}

final servDatabase = DatabaseService();
