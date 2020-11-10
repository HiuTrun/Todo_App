import 'package:eltodo/models/category.dart';
import 'package:eltodo/repositories/db_connection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

class Repository {
  DataBaseConnection _connection;

  Repository() {
    _connection = DataBaseConnection();
  }

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _connection.setDatabase();
    return _database;
  }

  save(table,data) async {
    var conn = await database;
    return await conn.insert(table, data);
  }

  getAll(table) async{
    var conn = await database;
    return await conn.query(table);
  }

  getById(table, itemId) async{
    var conn = await database;
    return await conn.query(table, where: "id=?", whereArgs: [itemId]);
    
  }

  update(table, data) async {
    var conn = await database;
    return await conn.update(table, data, where: 'id=?', whereArgs: [data['id']]);
  }

  delete(table, categoryId) async{
    var conn = await database;
    return await conn.delete(table, where:  'id=?', whereArgs: [categoryId]);
  }

  getByColumnName(String table, String columnName, String columnValue) async {
    var conn = await database;
    return await conn.query(table, where: '$columnName = ?',whereArgs: [columnValue]);
  }
}
