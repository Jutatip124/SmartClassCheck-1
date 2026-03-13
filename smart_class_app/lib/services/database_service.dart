import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/class_session.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'smart_class.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE sessions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            session_id TEXT NOT NULL,
            student_id TEXT NOT NULL,
            checkin_timestamp TEXT,
            checkin_lat REAL,
            checkin_lng REAL,
            qr_code_value TEXT,
            prev_topic TEXT,
            expected_topic TEXT,
            mood_score INTEGER,
            checkout_timestamp TEXT,
            checkout_lat REAL,
            checkout_lng REAL,
            learned_today TEXT,
            class_feedback TEXT,
            status TEXT DEFAULT 'pending'
          )
        ''');
      },
    );
  }

  /// Insert a new session record (check-in)
  Future<int> insertSession(ClassSession session) async {
    final db = await database;
    return await db.insert('sessions', session.toMap());
  }

  /// Update existing session (check-out)
  Future<int> updateSession(ClassSession session) async {
    final db = await database;
    return await db.update(
      'sessions',
      session.toMap(),
      where: 'session_id = ?',
      whereArgs: [session.sessionId],
    );
  }

  /// Get the most recent active session (status = 'checked_in')
  Future<ClassSession?> getActiveSession() async {
    final db = await database;
    final maps = await db.query(
      'sessions',
      where: 'status = ?',
      whereArgs: ['checked_in'],
      orderBy: 'id DESC',
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return ClassSession.fromMap(maps.first);
  }

  /// Get all sessions ordered by most recent
  Future<List<ClassSession>> getAllSessions() async {
    final db = await database;
    final maps = await db.query('sessions', orderBy: 'id DESC');
    return maps.map((m) => ClassSession.fromMap(m)).toList();
  }

  /// Get session by session_id
  Future<ClassSession?> getSessionById(String sessionId) async {
    final db = await database;
    final maps = await db.query(
      'sessions',
      where: 'session_id = ?',
      whereArgs: [sessionId],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return ClassSession.fromMap(maps.first);
  }

  /// Delete all sessions (for testing/reset)
  Future<void> clearAll() async {
    final db = await database;
    await db.delete('sessions');
  }
}
