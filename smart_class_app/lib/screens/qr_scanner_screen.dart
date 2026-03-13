import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../theme.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  MobileScannerController? controller;
  bool _scanned = false;
  final _manualController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      controller = MobileScannerController();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    _manualController.dispose();
    super.dispose();
  }

  void _returnValue(String value) {
    if (_scanned) return;
    setState(() => _scanned = true);
    controller?.stop();
    Navigator.pop(context, value);
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? _buildWebFallback() : _buildNativeScanner();
  }

  Widget _buildWebFallback() {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter QR Code')),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.qr_code, size: 56, color: Color(0xFF1565C0)),
              const SizedBox(height: 16),
              const Text('Enter Class QR Code',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              const Text(
                'Type the QR code value shown by your instructor.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _manualController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'QR Code value',
                  hintText: 'e.g. CS101-2026-001',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.qr_code_2),
                ),
                onSubmitted: (v) {
                  if (v.trim().isNotEmpty) _returnValue(v.trim());
                },
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () =>
                    _manualController.text = 'CS101-2026-001',
                child: const Text('Use Demo Code: CS101-2026-001'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  final v = _manualController.text.trim();
                  if (v.isNotEmpty) _returnValue(v);
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48)),
                child: const Text('Confirm'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNativeScanner() {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              icon: const Icon(Icons.flash_on),
              onPressed: () => controller?.toggleTorch()),
          IconButton(
              icon: const Icon(Icons.flip_camera_ios),
              onPressed: () => controller?.switchCamera()),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller!,
            onDetect: (capture) {
              if (_scanned) return;
              final value = capture.barcodes.firstOrNull?.rawValue;
              if (value != null) _returnValue(value);
            },
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Point camera at the class QR code',
                    style: TextStyle(color: Colors.white70, fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}