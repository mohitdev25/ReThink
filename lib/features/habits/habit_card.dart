import 'package:flutter/material.dart';
import 'package:rethink_app/core/ui/theme/app_colors.dart';
import 'package:rethink_app/core/ui/theme/app_typography.dart';
import 'package:rethink_app/core/ui/glass/interactive_glass.dart';

class HabitCard extends StatefulWidget {
  final String title;
  final int streak;
  final bool isCompleted;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const HabitCard({
    super.key,
    required this.title,
    required this.streak,
    required this.isCompleted,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> with SingleTickerProviderStateMixin {
  late final AnimationController _holdController;

  @override
  void initState() {
    super.initState();
    _holdController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _holdController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onToggle();
        _holdController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _holdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _holdController.forward(),
      onTapUp: (_) => _holdController.reverse(),
      onTapCancel: () => _holdController.reverse(),
      child: InteractiveGlass(
        onTap: () {}, // Handled by outer GestureDetector
        onLongPress: widget.onDelete, // Use InteractiveGlass's onLongPress which delegates to a ScaleTap
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            // Progress Bar Background
            AnimatedBuilder(
              animation: _holdController,
              builder: (context, child) {
                return FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _holdController.value,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryGlow,
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                  ),
                );
              },
            ),

            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: AppTypography.titleMedium.copyWith(
                      color: widget.isCompleted ? AppColors.success : AppColors.textPrimary,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.local_fire_department, color: AppColors.warning, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.streak}',
                        style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (widget.isCompleted) ...[
                        const SizedBox(width: 12),
                        const Icon(Icons.check_circle, color: AppColors.success),
                      ]
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
