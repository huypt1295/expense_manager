import 'package:expense_manager/features/profile_setting/presentation/profile/widget/section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';

class SupportSection extends StatelessWidget {
  const SupportSection({super.key, required this.onItemTap});

  final ValueChanged<SupportItem> onItemTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const items = [
      (SupportItem.helpCenter, 'Trung t\u00e2m tr\u1ee3 gi\u00fap'),
      (SupportItem.terms, '\u0110i\u1ec1u kho\u1ea3n d\u1ecbch v\u1ee5'),
      (SupportItem.privacy, 'Ch\u00ednh s\u00e1ch b\u1ea3o m\u1eadt'),
    ];

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'H\u1ed7 tr\u1ee3',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(items.length, (index) {
            final item = items[index];
            final isLast = index == items.length - 1;
            return Column(
              children: [
                SupportTile(label: item.$2, onTap: () => onItemTap(item.$1)),
                if (!isLast) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                ],
              ],
            );
          }),
        ],
      ),
    );
  }
}

class SupportTile extends StatelessWidget {
  const SupportTile({super.key,
    required this.label,
    this.trailing,
    this.onTap,
  });

  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.tpColors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (trailing != null) ...[trailing!, const SizedBox(width: 12)],
            Icon(Icons.chevron_right_rounded, color: colors.iconNeutral),
          ],
        ),
      ),
    );
  }
}

enum SupportItem { helpCenter, terms, privacy }
