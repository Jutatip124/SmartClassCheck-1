import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../models/class_session.dart';
import '../services/database_service.dart';
import '../services/location_service.dart';
import '../theme.dart';
import '../widgets/common_widgets.dart';
import 'qr_scanner_screen.dart';

class FinishClassScreen extends StatefulWidget {
  final ClassSession session;

  const FinishClassScreen({super.key, required this.session});

  @override
  State<FinishClassScreen> createState() => _FinishClassScreenState();
}

class _FinishClassScreenState extends State<FinishClassScreen> {
  final _formKey = GlobalKey<FormState>();
  final _learnedController = TextEditingController();
  final _feedbackController = TextEditingController();

  Position? _position;
  String? _qrValue;
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
    _learnedController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _captureLocation() async {
    setState(() => _isLoadingLocation = true);
    final pos = await _locationService.getCurrentLocation();
    setState(() {
      _position = pos;
      _isLoadingLocation = false;
    });
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

  Future<void> _submitFinishClass() async {
    if (!_formKey.currentState!.validate()) return;

    if (_qrValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please scan the class QR code to confirm attendance'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    final updatedSession = widget.session.copyWith(
      checkoutTimestamp: DateTime.now(),
      checkoutLat: _position?.latitude,
      checkoutLng: _position?.longitude,
      learnedToday: _learnedController.text.trim(),
      classFeedback: _feedbackController.text.trim(),
      status: 'completed',
    );

    await DatabaseService().updateSession(updatedSession);

    setState(() => _isSaving = false);

    if (mounted) {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle,
                  color: AppTheme.successGreen, size: 56),
            ),
            const SizedBox(height: 16),
            const Text('Class Completed!',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textDark)),
            const SizedBox(height: 8),
            const Text(
              'Your attendance and reflection have been saved.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textGray),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.successGreen),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finish Class'),
        backgroundColor: AppTheme.accentOrange,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTopBanner(),
              const SizedBox(height: 8),
              _buildCheckinSummary(),
              _buildQRSection(),
              _buildLocationSection(),
              _buildReflectionSection(),
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
      color: AppTheme.accentOrange,
      child: Column(
        children: [
          const Icon(Icons.logout, color: Colors.white, size: 32),
          const SizedBox(height: 6),
          const Text('End of Class Check-Out',
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

  Widget _buildCheckinSummary() {
    return SectionCard(
      title: 'Check-In Summary',
      icon: Icons.summarize,
      iconColor: AppTheme.primaryBlue,
      children: [
        _summaryRow('Session', widget.session.qrCodeValue ?? '—'),
        _summaryRow(
          'Checked in',
          widget.session.checkinTimestamp != null
              ? DateFormat('HH:mm').format(widget.session.checkinTimestamp!)
              : '—',
        ),
        _summaryRow(
          'Pre-class mood',
          widget.session.moodScore != null
              ? '${widget.session.moodEmoji} ${widget.session.moodLabel}'
              : '—',
        ),
      ],
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 13, color: AppTheme.textGray)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildQRSection() {
    return SectionCard(
      title: 'Step 1 — Scan QR Code Again',
      icon: Icons.qr_code_scanner,
      iconColor: AppTheme.accentOrange,
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
                : AppTheme.accentOrange,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return SectionCard(
      title: 'Step 2 — Confirm Location',
      icon: Icons.location_on,
      iconColor: AppTheme.successGreen,
      children: [
        GpsTile(
          lat: _position?.latitude,
          lng: _position?.longitude,
          isLoading: _isLoadingLocation,
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _isLoadingLocation ? null : _captureLocation,
          icon: const Icon(Icons.refresh, size: 18),
          label: const Text('Refresh Location'),
        ),
      ],
    );
  }

  Widget _buildReflectionSection() {
    return SectionCard(
      title: 'Step 3 — Post-Class Reflection',
      icon: Icons.edit_note,
      children: [
        TextFormField(
          controller: _learnedController,
          decoration: const InputDecoration(
            labelText: 'What did you learn today?',
            hintText: 'Summarize the main concepts from this class...',
            prefixIcon: Icon(Icons.lightbulb),
            alignLabelWithHint: true,
          ),
          maxLines: 3,
          validator: (v) =>
              v == null || v.trim().isEmpty ? 'Please share what you learned' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _feedbackController,
          decoration: const InputDecoration(
            labelText: 'Feedback for the class / instructor (optional)',
            hintText: 'Any suggestions or comments...',
            prefixIcon: Icon(Icons.feedback_outlined),
            alignLabelWithHint: true,
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: ElevatedButton(
        onPressed: _isSaving ? null : _submitFinishClass,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.accentOrange,
        ),
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
            : const Text('✓  Complete & Submit'),
      ),
    );
  }
}
