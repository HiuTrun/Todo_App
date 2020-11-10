import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DataBaseConnection {
  setDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');
    Database database = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreatingDatabase,
    );
    return database;
  }

  _onCreatingDatabase(Database db, int version) async {
    await db.execute("""
    CREATE TABLE categories(
    id INTEGER PRIMARY KEY, 
    name TEXT, 
    description TEXT)
    """);
    await db.execute("""
    CREATE TABLE todos(
    id INTEGER PRIMARY KEY, 
    title TEXT, 
    description TEXT,
    category TEXT,
    todoDate TEXT,
    isFinished INTEGER)
    """);
  }
}
