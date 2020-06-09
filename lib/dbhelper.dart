import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'period.dart';
import 'course.dart';
 

class DBHelperPeriod {
  static Database _db;
  static const String ID = 'id';
  static const String TITLE = 'title';
  static const String COURSEID = 'courseId';
  static const String STARTTIME = 'startTime';
  static const String ENDTIME = 'endTime';
  static const String DAY = 'day';
  static const String NOTIFICATION = 'notification';
    static const String NOTIFICATIONID = 'notificationId';
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
            "CREATE TABLE $TABLE ($ID TEXT PRIMARY KEY, $TITLE TEXT, $COURSEID TEXT, $STARTTIME INTEGER, $ENDTIME INTEGER, $DAY INTEGER, $NOTIFICATION INTEGER, $NOTIFICATIONID INTEGER)");
  }

  deleteTable(){
    db.then((value) => value.execute("DELETE FROM $TABLE"));
  }

  createTable(){
    db.then((value) => value.execute("CREATE TABLE $TABLE ($ID TEXT PRIMARY KEY, $TITLE TEXT, $COURSEID TEXT, $STARTTIME INTEGER, $ENDTIME INTEGER, $DAY INTEGER, $NOTIFICATION INTEGER, $NOTIFICATIONID INTEGER)"));
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
        .query(TABLE, columns: [ID, TITLE, COURSEID, STARTTIME, ENDTIME, DAY, NOTIFICATION, NOTIFICATIONID], orderBy: "$DAY, $STARTTIME, $ENDTIME");
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
            '$ID = ?',

        whereArgs: [
          period.id,
        ]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}


class DBHelperCourse {
  static Database _db;
  static const String ID = 'id';
  static const String TITLE = 'title';
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
        "CREATE TABLE $TABLE ($ID TEXT PRIMARY KEY, $TITLE TEXT, $COURSECODE TEXT, $DESCRIPTION TEXT)");
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
    db.then((value) => value.execute("CREATE TABLE $TABLE ($ID TEXT PRIMARY KEY, $TITLE TEXT, $COURSECODE TEXT, $DESCRIPTION TEXT)"));
  }

  Future<List<Course>> getCourses() async {
    var dbClient = await db;
    List<Map> maps = await dbClient
        .query(TABLE, columns: [ID, TITLE, COURSECODE, DESCRIPTION]);
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
            '$ID = ?',

        whereArgs: [
          course.id,
        ]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}