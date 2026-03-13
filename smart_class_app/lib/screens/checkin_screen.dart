import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../models/class_session.dart';
import '../services/database_service.dart';
import '../services/location_service.dart';
import '../theme.dart';
import '../widgets/common_widgets.dart';
import 'qr_scanner_screen.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _prevTopicController = TextEditingController();
  final _expectedTopicController = TextEditingController();

  Position? _position;
  String? _qrValue;
  int? _moodScore;
  bool _isLoadingLocation = false;
  bool _isSaving = false;

  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    _captureLocation();
  }

  @override
  void dispose() {
    _prevTopicController.dispose();
    _expectedTopicController.dispose();
    super.dispose();
  }

  Future<void> _captureLocation() async {
    setState(() => _isLoadingLocation = true);
    final pos = await _locationService.getCurrentLocation();
    setState(() {
      _position = pos;
      _isLoadingLocation = false;
    });
    if (pos == null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not get GPS location. Please enable location services.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _scanQR() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const QrScannerScreen()),
    );
    if (result != null) {
      setState(() => _qrValue = result);
    }
  }

  Future<void> _submitCheckIn() async {
    if (!_formKey.currentState!.validate()) return;

    if (_qrValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please scan the class QR code first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_moodScore == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your mood'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    final session = ClassSession(
      sessionId: const Uuid().v4(),
      studentId: 'student_001', // In production: use auth/profile
      checkinTimestamp: DateTime.now(),
      checkinLat: _position?.latitude,
      checkinLng: _position?.longitude,
      qrCodeValue: _qrValue,
      prevTopic: _prevTopicController.text.trim(),
      expectedTopic: _expectedTopicController.text.trim(),
      moodScore: _moodScore,
      status: 'checked_in',
    );

    await DatabaseService().insertSession(session);

    setState(() => _isSaving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✓ Checked in successfully!'),
          backgroundColor: AppTheme.successGreen,
        ),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Check In')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTopBanner(),
              const SizedBox(height: 8),
              _buildLocationSection(),
              _buildQRSection(),
              _buildReflectionSection(),
              _buildMoodSection(),
              _buildSubmitButton(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      color: AppTheme.primaryBlue,
      child: Column(
        children: [
          const Icon(Icons.login, color: Colors.white, size: 32),
          const SizedBox(height: 6),
          const Text('Class Check-In',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700)),
          Text(
            DateFormat('EEEE, MMM d • HH:mm').format(DateTime.now()),
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return SectionCard(
      title: 'Step 1 — Location',
      icon: Icons.location_on,
      iconColor: AppTheme.successGreen,
      children: [
        GpsTile(
          lat: _position?.latitude,
          lng: _position?.longitude,
          isLoading: _isLoadingLocation,
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: _isLoadingLocation ? null : _captureLocation,
          icon: const Icon(Icons.refresh, size: 18),
          label: const Text('Refresh Location'),
        ),
      ],
    );
  }

  Widget _buildQRSection() {
    return SectionCard(
      title: 'Step 2 — Scan QR Code',
      icon: Icons.qr_code_scanner,
      iconColor: AppTheme.primaryBlue,
      children: [
        QrResultTile(value: _qrValue),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: _scanQR,
          icon: const Icon(Icons.qr_code_scanner, size: 20),
          label: const Text('Scan Class QR Code'),
          style: ElevatedButton.styleFrom(
            backgroundColor: _qrValue != null
                ? AppTheme.successGreen
                : AppTheme.primaryBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildReflectionSection() {
    return SectionCard(
      title: 'Step 3 — Pre-Class Reflection',
      icon: Icons.edit_note,
      children: [
        TextFormField(
          controller: _prevTopicController,
          decoration: const InputDecoration(
            labelText: 'What topic was covered last class?',
            hintText: 'e.g. Flutter navigation and routing',
            prefixIcon: Icon(Icons.history_edu),
          ),
          maxLines: 2,
          validator: (v) =>
              v == null || v.trim().isEmpty ? 'Please fill in this field' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _expectedTopicController,
          decoration: const InputDecoration(
            labelText: 'What do you expect to learn today?',
            hintText: 'e.g. State management with Provider',
            prefixIcon: Icon(Icons.lightbulb_outline),
          ),
          maxLines: 2,
          validator: (v) =>
              v == null || v.trim().isEmpty ? 'Please fill in this field' : null,
        ),
      ],
    );
  }

  Widget _buildMoodSection() {
    return SectionCard(
      title: 'Step 4 — Your Mood Right Now',
      icon: Icons.mood,
      iconColor: AppTheme.accentOrange,
      children: [
        const Text('How are you feeling before class?',
            style: TextStyle(color: AppTheme.textGray, fontSize: 13)),
        const SizedBox(height: 12),
        MoodSelector(
          selectedMood: _moodScore,
          onMoodSelected: (score) => setState(() => _moodScore = score),
        ),
        if (_moodScore != null) ...[
          const SizedBox(height: 10),
          Center(
            child: Text(
              'Selected: ${_getMoodLabel(_moodScore!)}',
              style: const TextStyle(
                  color: AppTheme.primaryBlue, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ],
    );
  }

  String _getMoodLabel(int score) {
    const labels = {
      1: '😡 Very Negative',
      2: '🙁 Negative',
      3: '😐 Neutral',
      4: '🙂 Positive',
      5: '😄 Very Positive',
    };
    return labels[score] ?? 'Neutral';
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: ElevatedButton(
        onPressed: _isSaving ? null : _submitCheckIn,
        child: _isSaving
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  Text('Saving...'),
                ],
              )
            : const Text('✓  Submit Check-In'),
      ),
    );
  }
}
