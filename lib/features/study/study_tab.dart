import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rethink_app/core/ui/theme/app_colors.dart';
import 'package:rethink_app/core/ui/theme/app_typography.dart';
import 'package:rethink_app/core/ui/glass/base_glass.dart';
import 'package:rethink_app/core/ui/glass/interactive_glass.dart';
import 'package:rethink_app/core/ui/motion/flip_3d.dart';
import 'package:rethink_app/domain/providers/topics_provider.dart';
import 'package:rethink_app/domain/providers/stats_provider.dart';
import 'package:rethink_app/data/models/topic.dart';
import 'package:uuid/uuid.dart';

class StudyTab extends ConsumerStatefulWidget {
  const StudyTab({super.key});

  @override
  ConsumerState<StudyTab> createState() => _StudyTabState();
}

class _StudyTabState extends ConsumerState<StudyTab> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  void _addTopic() {
    if (_titleController.text.isEmpty) return;

    final topic = Topic(
      id: const Uuid().v4(),
      title: _titleController.text,
      notes: _notesController.text,
      interval: 1,
      nextReview: DateTime.now(),
    );

    ref.read(topicsProvider.notifier).addTopic(topic);
    _titleController.clear();
    _notesController.clear();
    Navigator.pop(context);
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
              Text('New Topic', style: AppTypography.titleLarge),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                style: AppTypography.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Topic Title',
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _notesController,
                style: AppTypography.bodyLarge,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Markdown Notes...',
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                  ElevatedButton(
                    onPressed: _addTopic,
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
    // Only get topics that need review today
    final reviews = ref.watch(todayReviewsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            title: const Text('Study', style: AppTypography.displayLarge),
            centerTitle: false,
            floating: true,
            actions: [
              IconButton(icon: const Icon(Icons.add), onPressed: _showAddDialog),
            ],
          ),
          if (reviews.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Text('All caught up for today!\nGreat job.',
                  textAlign: TextAlign.center,
                  style: AppTypography.titleMedium.copyWith(color: AppColors.success)),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _Flashcard(topic: reviews[index]),
                    );
                  },
                  childCount: reviews.length,
                ),
              ),
            )
        ],
      ),
    );
  }
}

class _Flashcard extends ConsumerStatefulWidget {
  final Topic topic;
  const _Flashcard({required this.topic});

  @override
  ConsumerState<_Flashcard> createState() => _FlashcardState();
}

class _FlashcardState extends ConsumerState<_Flashcard> {
  bool _showFront = true;

  void _grade(String grade) {
    ref.read(topicsProvider.notifier).gradeTopic(widget.topic.id, grade);
    ref.read(statsProvider.notifier).incrementTopicsStudied();
    setState(() => _showFront = true);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Flip3D(
        showFrontSide: _showFront,
        front: InteractiveGlass(
          onTap: () => setState(() => _showFront = false),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.topic.title, style: AppTypography.displayLarge, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                Text('Tap to flip', style: AppTypography.bodyMedium),
              ],
            ),
          ),
        ),
        back: BaseGlass(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Text(widget.topic.notes, style: AppTypography.bodyLarge),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _GradeButton(text: 'AGAIN', color: AppColors.error, onTap: () => _grade('AGAIN')),
                  _GradeButton(text: 'HARD', color: AppColors.warning, onTap: () => _grade('HARD')),
                  _GradeButton(text: 'GOOD', color: AppColors.primary, onTap: () => _grade('GOOD')),
                  _GradeButton(text: 'EASY', color: AppColors.success, onTap: () => _grade('EASY')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _GradeButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;

  const _GradeButton({required this.text, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(text, style: AppTypography.labelSmall.copyWith(color: color, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
