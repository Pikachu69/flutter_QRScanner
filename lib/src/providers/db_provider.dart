import 'dart:io';

import 'package:QReaderApp/src/models/scan_model.dart';
export 'package:QReaderApp/src/models/scan_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'ScanDB.db');

    return await openDatabase(
      path, 
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE scans ("
          "id INTEGER PRIMARY KEY,"
          "tipo TEXT,"
          "valor TEXT"
          ")"
        );
      }
    );
  }

  //Crear registros
  newScanRaw(ScanModel newscan) async {
    final db = await database;
    final res = await db.rawInsert(
      "INSERT INTO scans (id, tipo, valor) VALUES (${newscan.id}, '${newscan.tipo}', '${newscan.valor}')"
    );
    return res;
  }

  newScan(ScanModel newscan) async {
    final db = await database;
    final res = await db.insert('scans', newscan.toJson());
    return res;
  }

  //Select registros
  Future<ScanModel> getScanId (int id) async {
    final db = await database;
    final res = await db.query('scans', where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getAll() async{
    final db = await database;
    final res =  await db.query('scans');
    List<ScanModel> list = res.isNotEmpty ? res.map((e) => ScanModel.fromJson(e)).toList() : [];
    return list;
  }

  Future<List<ScanModel>> getAllType(String tipo) async{
    final db = await database;
    final res =  await db.rawQuery("SELECT * FROM scans WHERE tipo='$tipo'");
    List<ScanModel> list = res.isNotEmpty ? res.map((e) => ScanModel.fromJson(e)).toList() : [];
    return list;
  }

  //Update
  Future<int> updateScan(ScanModel newscan) async {
    final db = await database;
    final res = await db.update('scans', newscan.toJson(), where: 'id = ?', whereArgs: [newscan.id]);
    return res;
  }

  //Delete
  Future<int> deleteScan(int id) async {
    final db = await database;
    final res = await db.delete('scans', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAll() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM scans');
    return res;
  }
}