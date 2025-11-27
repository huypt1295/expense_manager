import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';

class SettingTile extends StatelessWidget {
  const SettingTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (trailing != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  trailing!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: context.tpColors.textSub,
                  ),
                ),
              ),
            Icon(
              Icons.chevron_right_rounded,
              color: context.tpColors.iconNeutral,
            ),
          ],
        ),
      ),
    );
  }
}
