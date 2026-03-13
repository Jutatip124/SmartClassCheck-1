import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/class_session.dart';
import '../services/database_service.dart';
import '../theme.dart';
import '../widgets/common_widgets.dart';
import 'checkin_screen.dart';
import 'finish_class_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ClassSession? _activeSession;
  List<ClassSession> _recentSessions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final db = DatabaseService();
    final active = await db.getActiveSession();
    final all = await db.getAllSessions();
    setState(() {
      _activeSession = active;
      _recentSessions = all.take(3).toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Class'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'History',
            onPressed: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const HistoryScreen()));
              _loadData();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    _buildStatusCard(),
                    _buildActionButtons(),
                    if (_recentSessions.isNotEmpty) _buildRecentSessions(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildHeader() {
    final now = DateTime.now();
    final greeting = now.hour < 12
        ? 'Good Morning'
        : now.hour < 17
            ? 'Good Afternoon'
            : 'Good Evening';
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryBlue, AppTheme.lightBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(greeting,
              style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 4),
          const Text('Student',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(
            DateFormat('EEEE, MMMM d, yyyy').format(now),
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Transform.translate(
      offset: const Offset(0, -16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _activeSession != null
                        ? Colors.blue.shade50
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _activeSession != null
                        ? Icons.school
                        : Icons.radio_button_unchecked,
                    color: _activeSession != null
                        ? AppTheme.primaryBlue
                        : AppTheme.textGray,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Today\'s Status',
                          style: TextStyle(
                              fontSize: 12, color: AppTheme.textGray)),
                      const SizedBox(height: 4),
                      StatusBadge(
                          status: _activeSession?.status ?? 'pending'),
                      if (_activeSession != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'QR: ${_activeSession!.qrCodeValue ?? "—"}',
                          style: const TextStyle(
                              fontSize: 12, color: AppTheme.textGray),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final isCheckedIn = _activeSession != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          if (!isCheckedIn)
            ElevatedButton.icon(
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const CheckInScreen()));
                _loadData();
              },
              icon: const Icon(Icons.login, size: 22),
              label: const Text('Check In to Class'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                minimumSize: const Size(double.infinity, 56),
              ),
            ),
          if (isCheckedIn) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      color: AppTheme.primaryBlue, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'You are checked in. Finish class when the session ends.',
                      style: TextStyle(
                          color: Colors.blue.shade800, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => FinishClassScreen(
                            session: _activeSession!)));
                _loadData();
              },
              icon: const Icon(Icons.logout, size: 22),
              label: const Text('Finish Class'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentOrange,
                minimumSize: const Size(double.infinity, 56),
              ),
            ),
          ],
          const SizedBox(height: 12),
          // Demo QR generator button
          OutlinedButton.icon(
            onPressed: () => _showDemoQR(context),
            icon: const Icon(Icons.qr_code),
            label: const Text('Show Demo Class QR'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }

  void _showDemoQR(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Demo Class QR Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Scan this QR code to test the app:',
                style: TextStyle(fontSize: 13, color: AppTheme.textGray)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  // Simple QR representation using grid
                  _buildSimpleQRDisplay('CS101-2026-001'),
                  const SizedBox(height: 8),
                  const Text('CS101-2026-001',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: 'monospace')),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          )
        ],
      ),
    );
  }

  Widget _buildSimpleQRDisplay(String value) {
    // Visual QR code pattern (static demo representation)
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: CustomPaint(
        painter: SimpleQRPainter(value),
      ),
    );
  }

  Widget _buildRecentSessions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: Text('Recent Sessions',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark)),
        ),
        ..._recentSessions.map((s) => _buildSessionTile(s)),
      ],
    );
  }

  Widget _buildSessionTile(ClassSession session) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Container(
          width: 42,
          height: 42,
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
            size: 22,
          ),
        ),
        title: Text(session.qrCodeValue ?? 'Session',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text(
          session.checkinTimestamp != null
              ? DateFormat('MMM d, HH:mm').format(session.checkinTimestamp!)
              : '—',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: StatusBadge(status: session.status),
      ),
    );
  }
}

/// Simple QR-like visual painter for demo
class SimpleQRPainter extends CustomPainter {
  final String value;
  SimpleQRPainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black;
    final cellSize = size.width / 10;

    // Draw a simple deterministic pattern based on value hash
    final hash = value.hashCode.abs();
    for (int i = 0; i < 10; i++) {
      for (int j = 0; j < 10; j++) {
        if ((hash >> (i * 3 + j)) % 3 == 0 ||
            (i < 3 && j < 3) ||
            (i < 3 && j > 6) ||
            (i > 6 && j < 3)) {
          canvas.drawRect(
            Rect.fromLTWH(i * cellSize, j * cellSize, cellSize, cellSize),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
