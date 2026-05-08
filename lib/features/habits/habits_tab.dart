import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rethink_app/core/ui/theme/app_colors.dart';
import 'package:rethink_app/core/ui/theme/app_typography.dart';
import 'package:rethink_app/core/ui/glass/base_glass.dart';
import 'package:rethink_app/domain/providers/habits_provider.dart';
import 'package:rethink_app/domain/providers/stats_provider.dart';
import 'package:rethink_app/features/habits/habit_card.dart';
import 'package:rethink_app/core/utils/dates.dart';
import 'package:rethink_app/data/models/habit.dart';
import 'package:uuid/uuid.dart';

class HabitsTab extends ConsumerStatefulWidget {
  const HabitsTab({super.key});

  @override
  ConsumerState<HabitsTab> createState() => _HabitsTabState();
}

class _HabitsTabState extends ConsumerState<HabitsTab> {
  final TextEditingController _controller = TextEditingController();

  void _addHabit() {
    if (_controller.text.isEmpty) return;

    final habit = Habit(
      id: const Uuid().v4(),
      title: _controller.text,
      streak: 0,
    );

    ref.read(habitsProvider.notifier).addHabit(habit);
    _controller.clear();
    Navigator.of(context).pop();
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: BaseGlass(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('New Habit', style: AppTypography.titleLarge),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                style: AppTypography.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'E.g. Drink Water',
                  hintStyle: AppTypography.bodyLarge.copyWith(color: AppColors.textTertiary),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: AppColors.surface,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel', style: AppTypography.bodyMedium),
                  ),
                  ElevatedButton(
                    onPressed: _addHabit,
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                    child: const Text('Add'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final habits = ref.watch(habitsProvider);
    final today = DateUtils.normalizedToday;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            title: const Text('Habits', style: AppTypography.displayLarge),
            centerTitle: false,
            floating: true,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final habit = habits[index];
                  final isCompleted = habit.completedDates.any((d) => DateUtils.isSameDay(d, today));

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: HabitCard(
                      title: habit.title,
                      streak: habit.streak,
                      isCompleted: isCompleted,
                      onToggle: () {
                        ref.read(habitsProvider.notifier).toggleCompletion(habit.id);
                        if (!isCompleted) {
                           ref.read(statsProvider.notifier).incrementHabitsCompleted();
                           // Simple global streak logic for stats
                           ref.read(statsProvider.notifier).updateStreak(habit.streak + 1);
                        }
                      },
                      onDelete: () {
                        ref.read(habitsProvider.notifier).deleteHabit(habit.id);
                      },
                    ),
                  );
                },
                childCount: habits.length,
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
