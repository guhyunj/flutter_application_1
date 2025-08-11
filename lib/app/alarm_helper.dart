import 'package:sqflite/sqflite.dart';

import 'data/models/alarm_info.dart';

final String tableAlarm = "alarm";
final String columnId = "id";
final String columnTitle = "title";
final String columnDateTime = "dateTime";
final String columnPending = "isPending";
final String columnColorIndex = "gradientColorIndex";

class AlarmHelper {
  static Database? _database;
  static AlarmHelper? _alarmHelper;

  AlarmHelper._createInstance();
  factory AlarmHelper() {
    if (_alarmHelper == null) {
      _alarmHelper = AlarmHelper._createInstance();
    }
    return _alarmHelper!;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = '${dir}alarms.db';
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          create table $tableAlarm (
            $columnId integer primary key autoincrement,
            $columnTitle text not null,
            $columnDateTime text not null,
            $columnPending integer not null,
            $columnColorIndex integer not null
          )
        ''');
      },
    );
    return database;
  }

  Future<void> insertAlarm(AlarmInfo alarmInfo) async {
    var db = await database;
    var result = await db.insert(tableAlarm, alarmInfo.toMap());
    // Use a logging framework or remove this line in production.
    // print("Alarm inserted with id: $result");
  }

  Future<List<AlarmInfo>> getAlarms() async {
    List<AlarmInfo> _alarms = [];
    var db = await database;
    var result = await db.query(tableAlarm);
    for (var element in result) {
      _alarms.add(AlarmInfo.fromMap(element));
    }
    return _alarms;
  }

  Future<int> delete(int? id) async {
    var db = await database;
    return await db.delete(tableAlarm, where: '$columnId = ?', whereArgs: [id]);
  }
}
