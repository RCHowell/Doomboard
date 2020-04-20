import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'model.dart';

abstract class Repo {
  Future<List<Problem>> get(Filter f, String s);
  Future update(Problem p);
}

class SqliteRepo implements Repo {
  Database _db;
  bool _initialized;

  SqliteRepo() {
    _initialized = false;
  }

  Future _initialize() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "db.sqlite3");
    var exists = await databaseExists(path);
    if (!exists) {
      print("Creating new copy from asset");
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data = await rootBundle.load(join("assets", "asset_db.sqlite3"));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
    this._db = await openDatabase("db.sqlite3");
    _initialized = true;
  }

  @override
  Future<List<Problem>> get(Filter f, String s) async {
    if (!_initialized) await this._initialize();
    String query = '''
    SELECT * FROM problems
    WHERE
      quality BETWEEN ${f.minQuality} AND ${f.maxQuality} 
      AND
      grade_a BETWEEN ${f.minGradeA} AND ${f.maxGradeA}
      AND
      grade_b BETWEEN ${f.minGradeB} AND ${f.maxGradeB} 
    ''';
    if (f.hideSends) query += ' AND sent=0';
    if (s.isNotEmpty) query += ' AND name LIKE "%$s%" LIMIT 50';
    List<Map> results = await this._db.rawQuery(query);
    return results.map((p) => Problem.fromMap(p)).toList();
  }

  @override
  Future update(Problem p) async {
    if (!_initialized) await this._initialize();
    return await this._db.update(
      'problems',
      p.toMap(),
      where: 'id = ?',
      whereArgs: [p.id],
    );
  }

  Future<List<Problem>> getAll() async {
    if (!_initialized) await this._initialize();
    String query = 'SELECT * FROM problems';
    List<Map> results = await this._db.rawQuery(query);
    return results.map((p) => Problem.fromMap(p)).toList();
  }

}

class MemRepo implements Repo {
  Map<int, Problem> _problems = {
    0: Problem(
      id: 0,
      name: "Route 1",
      spray: "Decent",
      moves: ["AB", "BC", "CD"],
      quality: Quality.STAR,
      gradeA: 3,
      gradeB: 2,
      sent: true,
    ),
    1: Problem(
      id: 1,
      name: "Other Route",
      spray: "Garbage",
      moves: ["AB", "BC", "CD"],
      quality: Quality.BOMB,
      gradeA: 2,
      gradeB: 1,
      sent: true,
    ),
    2: Problem(
      id: 2,
      name: "Proj",
      spray: "",
      moves: ["AB", "BC", "CD"],
      quality: Quality.STAR,
      gradeA: 4,
      gradeB: 4,
      sent: false,
    ),
  };

  @override
  Future<List<Problem>> get(Filter f, String s) =>
      Future.delayed(Duration(milliseconds: 200))
          .then((_) => Future.value(_problems.values.toList()));

  @override
  Future update(Problem p) {
    if (!_problems.containsKey(p.id)) throw ('No route with that id');
    _problems[p.id] = p;
    return Future.value();
  }

}
