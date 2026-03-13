import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'theme.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };

  runApp(const SmartClassApp());
}

class SmartClassApp extends StatelessWidget {
  const SmartClassApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Class',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const HomeScreen(),
    );
  }
}