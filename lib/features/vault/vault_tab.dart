import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rethink_app/core/ui/theme/app_colors.dart';
import 'package:rethink_app/core/ui/theme/app_typography.dart';
import 'package:rethink_app/core/ui/glass/interactive_glass.dart';
import 'package:rethink_app/domain/providers/vault_provider.dart';

class VaultTab extends ConsumerWidget {
  const VaultTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final files = ref.watch(vaultProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            title: const Text('Library', style: AppTypography.displayLarge),
            centerTitle: false,
            floating: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  ref.read(vaultProvider.notifier).pickFile();
                },
              )
            ],
          ),
          if (files.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Text('Your offline library is empty.\nTap + to add PDFs or images.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final file = files[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: InteractiveGlass(
                        onTap: () {
                          // Handle file opening here (e.g. using open_file package)
                        },
                        onLongPress: () {
                          ref.read(vaultProvider.notifier).removeFile(file.id);
                        },
                        child: Row(
                          children: [
                            Icon(
                              file.type == 'pdf' ? Icons.picture_as_pdf : Icons.image,
                              color: AppColors.primary,
                              size: 32,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                file.name,
                                style: AppTypography.titleMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: files.length,
                ),
              ),
            )
        ],
      ),
    );
  }
}
