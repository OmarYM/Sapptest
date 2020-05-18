import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'period.dart';
import 'course.dart';
 

class DBHelperPeriod {
  static Database _db;
  static const String ID = 'title';
  static const String COURSE = 'course';
  static const String STARTTIME = 'startTime';
  static const String ENDTIME = 'endTime';
  static const String DAY = 'day';
  static const String TABLE = 'periods';
  static const String DB_NAME = 'period1.db';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($ID TEXT PRIMARY KEY, $COURSE TEXT, $STARTTIME INTEGER, $ENDTIME INTEGER, $DAY INTEGER)");
  }

  deleteTable(){
    db.then((value) => value.execute("DELETE FROM $TABLE"));
  }

  createTable(){
    db.then((value) => value.execute("CREATE TABLE $TABLE ($ID TEXT PRIMARY KEY, $COURSE TEXT, $STARTTIME INTEGER, $ENDTIME INTEGER, $DAY INTEGER)"));
  }

  Future<Period> save(Period period) async {
    var dbClient = await db;
    await dbClient.insert(TABLE, period.toMap());
    return period;
    /*
    await dbClient.transaction((txn) async {
      var query = "INSERT INTO $TABLE ($NAME) VALUES ('" + period.name + "')";
      return await txn.rawInsert(query);
    });
    */
  }

  Future<List<Period>> getPeriods() async {
    var dbClient = await db;
    List<Map> maps = await dbClient
        .query(TABLE, columns: [ID, COURSE, STARTTIME, ENDTIME, DAY], orderBy: "$DAY, $STARTTIME, $ENDTIME");
    //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<Period> periods = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        periods.add(Period.fromMap(maps[i]));
      }
    }
    return periods;
  }

  Future<int> delete(String id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> update(Period period) async {
    var dbClient = await db;
    var map = period.toMap();
    return await dbClient.update(TABLE, map,
        where:
            '$ID = ? AND $COURSE = ? AND $STARTTIME = ? AND $ENDTIME = ? AND $DAY = ?',

        whereArgs: [
          period.title,
          map['course'],
          map['startTime'],
          map['endTime'],
          map['day']
        ]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}


class DBHelperCourse {
  static Database _db;
  static const String ID = 'title';
  static const String COURSECODE = 'courseCode';
  static const String DESCRIPTION = 'description';
  static const String TABLE = 'courses';
  static const String DB_NAME = 'courser1.db';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($ID TEXT PRIMARY KEY, $COURSECODE TEXT, $DESCRIPTION TEXT)");
  }

  Future<Course> save(Course course) async {
    var dbClient = await db;
    await dbClient.insert(TABLE, course.toMap());
    return course;
    /*
    await dbClient.transaction((txn) async {
      var query = "INSERT INTO $TABLE ($NAME) VALUES ('" + Course.name + "')";
      return await txn.rawInsert(query);
    });
    */
  }

  deleteTable(){
    db.then((value) => value.execute("DELETE FROM $TABLE"));
  }

  createTable(){
    db.then((value) => value.execute("CREATE TABLE $TABLE ($ID TEXT PRIMARY KEY, $COURSECODE TEXT, $DESCRIPTION TEXT)"));
  }

  Future<List<Course>> getCourses() async {
    var dbClient = await db;
    List<Map> maps = await dbClient
        .query(TABLE, columns: [ID, COURSECODE, DESCRIPTION]);
    //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<Course> courses = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        courses.add(Course.fromMap(maps[i]));
      }
    }
    return courses;
  }

  Future<int> delete(String id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> update(Course course) async {
    var dbClient = await db;
    var map = course.toMap();
    return await dbClient.update(TABLE, map,
        where:
            '$ID = ? AND $COURSECODE = ? AND $DESCRIPTION = ?',

        whereArgs: [
          course.title,
          map['courseCode'],
          map['description']
        ]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}