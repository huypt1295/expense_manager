import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_resource/flutter_resource.dart';

class WorkspaceConfirmationSheet extends StatelessWidget {
  const WorkspaceConfirmationSheet({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.confirmLabel,
    this.extra,
    this.onConfirm,
  });

  final IconData icon;
  final String title;
  final String message;
  final String confirmLabel;
  final Widget? extra;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    return CommonBottomSheet(
      title: '',
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.tpColors.surfaceWarning,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: context.tpColors.iconNegative, size: 32),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: TPTextStyle.titleM.copyWith(
                color: context.tpColors.textMain,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TPTextStyle.bodyM.copyWith(
                color: context.tpColors.textSub,
              ),
            ),
            if (extra != null) extra!,
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: CommonPrimaryButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    backgroundColor: context.tpColors.surfaceSub,
                    child: Text(
                      S.current.cancel,
                      style: TPTextStyle.bodyM.copyWith(
                        color: context.tpColors.textMain,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: CommonPrimaryButton(
                    onPressed: onConfirm,
                    backgroundColor: context.tpColors.surfaceNegativeComponent,
                    child: Text(
                      confirmLabel,
                      style: TPTextStyle.bodyM.copyWith(
                        color: context.tpColors.textReverse,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
