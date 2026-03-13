import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/class_session.dart';
import '../services/database_service.dart';
import '../theme.dart';
import '../widgets/common_widgets.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<ClassSession> _sessions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    setState(() => _isLoading = true);
    final sessions = await DatabaseService().getAllSessions();
    setState(() {
      _sessions = sessions;
      _isLoading = false;
    });
  }

  Future<void> _clearAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Sessions?'),
        content: const Text('This will delete all session history. This cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Clear', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirmed == true) {
      await DatabaseService().clearAll();
      _loadSessions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session History'),
        actions: [
          if (_sessions.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Clear all',
              onPressed: _clearAll,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _sessions.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  itemCount: _sessions.length,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemBuilder: (ctx, i) => _buildSessionCard(_sessions[i]),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text('No sessions yet',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textGray)),
          const SizedBox(height: 8),
          const Text('Check in to a class to see your history',
              style: TextStyle(color: AppTheme.textGray)),
        ],
      ),
    );
  }

  Widget _buildSessionCard(ClassSession session) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ExpansionTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: session.status == 'completed'
                ? Colors.green.shade50
                : Colors.blue.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            session.status == 'completed'
                ? Icons.check_circle_outline
                : Icons.login,
            color: session.status == 'completed'
                ? AppTheme.successGreen
                : AppTheme.primaryBlue,
          ),
        ),
        title: Text(
          session.qrCodeValue ?? 'Session',
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        subtitle: Row(
          children: [
            Text(
              session.checkinTimestamp != null
                  ? DateFormat('MMM d, HH:mm').format(session.checkinTimestamp!)
                  : '—',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(width: 8),
            StatusBadge(status: session.status),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                if (session.checkinLat != null)
                  _detailRow(Icons.location_on, 'Check-in GPS',
                      '${session.checkinLat!.toStringAsFixed(5)}, ${session.checkinLng!.toStringAsFixed(5)}'),
                if (session.prevTopic != null && session.prevTopic!.isNotEmpty)
                  _detailRow(Icons.history_edu, 'Previous topic', session.prevTopic!),
                if (session.expectedTopic != null && session.expectedTopic!.isNotEmpty)
                  _detailRow(Icons.lightbulb_outline, 'Expected today', session.expectedTopic!),
                if (session.moodScore != null)
                  _detailRow(Icons.mood, 'Pre-class mood',
                      '${session.moodEmoji} ${session.moodLabel}'),
                if (session.status == 'completed') ...[
                  const Divider(),
                  if (session.checkoutTimestamp != null)
                    _detailRow(Icons.logout, 'Checked out',
                        DateFormat('HH:mm').format(session.checkoutTimestamp!)),
                  if (session.checkoutLat != null)
                    _detailRow(Icons.location_on_outlined, 'Check-out GPS',
                        '${session.checkoutLat!.toStringAsFixed(5)}, ${session.checkoutLng!.toStringAsFixed(5)}'),
                  if (session.learnedToday != null && session.learnedToday!.isNotEmpty)
                    _detailRow(Icons.lightbulb, 'Learned today', session.learnedToday!),
                  if (session.classFeedback != null && session.classFeedback!.isNotEmpty)
                    _detailRow(Icons.feedback, 'Feedback', session.classFeedback!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppTheme.textGray),
          const SizedBox(width: 8),
          SizedBox(
            width: 110,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textGray,
                    fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
