import 'package:flutter/material.dart';
import 'package:rethink_app/core/ui/theme/app_colors.dart';
import 'package:rethink_app/features/study/study_tab.dart';
import 'package:rethink_app/features/habits/habits_tab.dart';
import 'package:rethink_app/features/vault/vault_tab.dart';
import 'package:rethink_app/features/profile/profile_tab.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    StudyTab(),
    HabitsTab(),
    VaultTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Ambient background glow
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.15),
                blurFilter: const MaskFilter.blur(BlurStyle.normal, 100),
              ),
            ),
          ),
          SafeArea(child: _tabs[_currentIndex]),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          backgroundColor: AppColors.surface.withOpacity(0.9),
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textTertiary,
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Study'),
            BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), label: 'Habits'),
            BottomNavigationBarItem(icon: Icon(Icons.folder_copy), label: 'Vault'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
