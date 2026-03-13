import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/class_session.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static const _sessionsKey = 'smart_class_sessions';

  Future<List<ClassSession>> _readAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_sessionsKey) ?? [];
    return raw
        .map((s) => ClassSession.fromMap(jsonDecode(s) as Map<String, dynamic>))
        .toList();
  }

  Future<void> _writeAll(List<ClassSession> sessions) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = sessions.map((s) => jsonEncode(s.toMap())).toList();
    await prefs.setStringList(_sessionsKey, raw);
  }

  Future<int> insertSession(ClassSession session) async {
    final all = await _readAll();
    all.insert(0, session);
    await _writeAll(all);
    return all.length;
  }

  Future<int> updateSession(ClassSession updated) async {
    final all = await _readAll();
    final idx = all.indexWhere((s) => s.sessionId == updated.sessionId);
    if (idx == -1) return 0;
    all[idx] = updated;
    await _writeAll(all);
    return 1;
  }

  Future<ClassSession?> getActiveSession() async {
    final all = await _readAll();
    try {
      return all.firstWhere((s) => s.status == 'checked_in');
    } catch (_) {
      return null;
    }
  }

  Future<List<ClassSession>> getAllSessions() async {
    return _readAll();
  }

  Future<ClassSession?> getSessionById(String sessionId) async {
    final all = await _readAll();
    try {
      return all.firstWhere((s) => s.sessionId == sessionId);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearAll() async {
    await _writeAll([]);
  }
}