import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rethink_app/core/storage/hive_setup.dart';
import 'package:rethink_app/features/dashboard/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveSetup.init();

  runApp(
    const ProviderScope(
      child: ReThinkApp(),
    ),
  );
}

class ReThinkApp extends StatelessWidget {
  const ReThinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReThink',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1A1A1D), // AppColors.background
        fontFamily: '.SF Pro Display',
      ),
      home: const DashboardScreen(),
    );
  }
}
