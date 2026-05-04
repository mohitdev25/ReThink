import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rethink_app/core/ui/theme/app_colors.dart';
import 'package:rethink_app/core/ui/theme/app_typography.dart';
import 'package:rethink_app/core/ui/glass/base_glass.dart';
import 'package:rethink_app/domain/providers/stats_provider.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            title: const Text('Profile & Stats', style: AppTypography.displayLarge),
            centerTitle: false,
            floating: true,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Stats Grid
                Row(
                  children: [
                    Expanded(child: _StatCard(title: 'Topics Studied', value: '${stats.totalTopicsStudied}')),
                    const SizedBox(width: 12),
                    Expanded(child: _StatCard(title: 'Habits Done', value: '${stats.totalHabitsCompleted}')),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _StatCard(title: 'Current Streak', value: '${stats.currentStreak} 🔥')),
                    const SizedBox(width: 12),
                    Expanded(child: _StatCard(title: 'Longest Streak', value: '${stats.longestStreak} 🏆')),
                  ],
                ),
                const SizedBox(height: 32),

                // Medals Section
                const Text('Medals', style: AppTypography.titleLarge),
                const SizedBox(height: 16),
                if (stats.medals.isEmpty)
                  Text('Keep studying to earn medals!', style: AppTypography.bodyMedium),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: stats.medals.map((m) => BaseGlass(
                    padding: const EdgeInsets.all(12),
                    child: Text(m, style: AppTypography.titleMedium),
                  )).toList(),
                ),
                const SizedBox(height: 32),

                // AI Placeholders
                const Text('Coming Soon', style: AppTypography.titleLarge),
                const SizedBox(height: 16),
                _AiFeatureCard(
                  icon: Icons.quiz,
                  title: 'AI Smart Quiz',
                  subtitle: 'Automatically generate quizzes from your Markdown notes.',
                ),
                const SizedBox(height: 12),
                _AiFeatureCard(
                  icon: Icons.slideshow,
                  title: 'AI Slide Generator',
                  subtitle: 'Convert notes into beautiful presentation slides.',
                ),
              ]),
            ),
          )
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return BaseGlass(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: AppTypography.displayLarge.copyWith(color: AppColors.primary)),
          const SizedBox(height: 8),
          Text(title, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }
}

class _AiFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _AiFeatureCard({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return BaseGlass(
      opacity: 0.05, // Dimmer to indicate it's not active yet
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryGlow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppColors.primary, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleMedium),
                const SizedBox(height: 4),
                Text(subtitle, style: AppTypography.bodyMedium),
              ],
            ),
          )
        ],
      ),
    );
  }
}
