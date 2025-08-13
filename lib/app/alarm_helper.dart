import 'package:sqflite/sqflite.dart';

import 'data/models/alarm_info.dart';

/// 알람 데이터베이스 테이블 및 컬럼 상수 정의
final String tableAlarm = "alarm";
final String columnId = "id";
final String columnTitle = "title";
final String columnDateTime = "dateTime";
final String columnPending = "isPending";
final String columnColorIndex = "gradientColorIndex";

/// SQLite 데이터베이스를 사용하여 알람 정보를 관리하는 헬퍼 클래스
/// 싱글톤 패턴을 사용하여 인스턴스를 관리합니다.
class AlarmHelper {
  /// 데이터베이스 인스턴스
  static Database? _database;
  /// AlarmHelper 싱글톤 인스턴스
  static AlarmHelper? _alarmHelper;

  /// private 생성자 (싱글톤 패턴)
  AlarmHelper._createInstance();
  
  /// 팩토리 생성자 - 싱글톤 인스턴스를 반환
  factory AlarmHelper() {
    if (_alarmHelper == null) {
      _alarmHelper = AlarmHelper._createInstance();
    }
    return _alarmHelper!;
  }

  /// 데이터베이스 인스턴스를 반환하는 getter
  /// 데이터베이스가 초기화되지 않았다면 초기화 후 반환
  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  /// SQLite 데이터베이스를 초기화하고 알람 테이블을 생성
  /// 데이터베이스 파일 경로: {databasePath}/alarms.db
  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = '${dir}alarms.db';
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        // 알람 테이블 생성 SQL
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

  /// 새로운 알람 정보를 데이터베이스에 삽입
  /// [alarmInfo]: 저장할 알람 정보 객체
  Future<void> insertAlarm(AlarmInfo alarmInfo) async {
    var db = await database;
    var result = await db.insert(tableAlarm, alarmInfo.toMap());
    
    print("Alarm inserted with id: $result");
  }

  /// 데이터베이스에서 모든 알람 정보를 조회하여 반환
  /// Returns: AlarmInfo 객체들의 리스트
  Future<List<AlarmInfo>> getAlarms() async {
    List<AlarmInfo> _alarms = [];
    var db = await database;
    var result = await db.query(tableAlarm);
    for (var element in result) {
      _alarms.add(AlarmInfo.fromMap(element));
    }
    return _alarms;
  }

  /// 지정된 ID의 알람을 데이터베이스에서 삭제
  /// [id]: 삭제할 알람의 고유 ID
  /// Returns: 삭제된 행의 개수
  Future<int> delete(int? id) async {
    var db = await database;
    return await db.delete(tableAlarm, where: '$columnId = ?', whereArgs: [id]);
  }
}
