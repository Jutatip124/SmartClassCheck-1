import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../theme.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  MobileScannerController controller = MobileScannerController();
  bool _scanned = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => controller.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_ios),
            onPressed: () => controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              if (_scanned) return;
              final barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final value = barcodes.first.rawValue;
                if (value != null) {
                  setState(() => _scanned = true);
                  controller.stop();
                  Navigator.pop(context, value);
                }
              }
            },
          ),
          // Scanning overlay
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
                  child: Stack(
                    children: [
                      // Corner decorations
                      _corner(Alignment.topLeft),
                      _corner(Alignment.topRight),
                      _corner(Alignment.bottomLeft),
                      _corner(Alignment.bottomRight),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Point camera at the class QR code',
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _corner(Alignment alignment) {
    final isTop = alignment == Alignment.topLeft || alignment == Alignment.topRight;
    final isLeft = alignment == Alignment.topLeft || alignment == Alignment.bottomLeft;
    return Align(
      alignment: alignment,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          border: Border(
            top: isTop ? const BorderSide(color: AppTheme.lightBlue, width: 4) : BorderSide.none,
            bottom: !isTop ? const BorderSide(color: AppTheme.lightBlue, width: 4) : BorderSide.none,
            left: isLeft ? const BorderSide(color: AppTheme.lightBlue, width: 4) : BorderSide.none,
            right: !isLeft ? const BorderSide(color: AppTheme.lightBlue, width: 4) : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
