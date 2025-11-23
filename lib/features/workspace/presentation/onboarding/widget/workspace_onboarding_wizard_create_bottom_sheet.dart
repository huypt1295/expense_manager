import 'package:expense_manager/core/auth/current_user.dart';
import 'package:expense_manager/features/workspace/presentation/onboarding/cubit/workspace_onboarding_cubit.dart';
import 'package:expense_manager/features/workspace/presentation/onboarding/cubit/workspace_onboarding_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart';

class WorkspaceOnboardingWizardCreateBottomSheet extends StatefulWidget {
  const WorkspaceOnboardingWizardCreateBottomSheet({super.key});

  @override
  State<WorkspaceOnboardingWizardCreateBottomSheet> createState() =>
      WorkspaceOnboardingWizardCreateBottomSheetState();
}

class WorkspaceOnboardingWizardCreateBottomSheetState
    extends State<WorkspaceOnboardingWizardCreateBottomSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return BlocConsumer<WorkspaceOnboardingCubit, WorkspaceOnboardingState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage ||
          previous.completedWorkspaceId != current.completedWorkspaceId,
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
        if (state.isCompleted) {
          Navigator.of(context).maybePop(
            WorkspaceCreationResult(
              workspaceId: state.completedWorkspaceId!,
              workspaceName: state.name.trim(),
            ),
          );
        }
      },
      builder: (context, state) {
        if (_controller.text != state.name) {
          _controller.value = TextEditingValue(
            text: state.name,
            selection: TextSelection.collapsed(offset: state.name.length),
          );
        }
        final owner = tpGetIt.get<CurrentUser>().now()?.displayName ?? 'Bạn';
        final theme = Theme.of(context);
        final isBusy = state.isSubmitting;
        final canSubmit = state.canSubmit && !isBusy;

        return AnimatedPadding(
          duration: const Duration(milliseconds: 250),
          padding: EdgeInsets.only(bottom: bottomInset),
          child: _BaseBottomSheet(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      TextButton(
                        onPressed: isBusy
                            ? null
                            : () => Navigator.of(context).maybePop(),
                        child: Text(S.current.cancel),
                      ),
                      Expanded(
                        child: Text(
                          S.current.create_workspace,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 64),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    S.current.workspace_wizard_choose_icon,
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: List.generate(
                      _iconOptions.length,
                      (index) => _IconChoice(
                        option: _iconOptions[index],
                        selected: state.iconIndex == index,
                        onTap: isBusy
                            ? null
                            : () => context
                                  .read<WorkspaceOnboardingCubit>()
                                  .selectIcon(index),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _controller,
                    enabled: !isBusy,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: S.current.create_workspace,
                      hintText: 'VD: Gia đình Cam',
                    ),
                    onChanged: context
                        .read<WorkspaceOnboardingCubit>()
                        .updateName,
                  ),
                  const SizedBox(height: 16),
                  if (state.name.trim().isNotEmpty)
                    _WorkspacePreviewCard(
                      option: _iconOptions[state.iconIndex],
                      name: state.name.trim(),
                      ownerName: owner,
                    ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: canSubmit
                          ? () => context
                                .read<WorkspaceOnboardingCubit>()
                                .submit()
                          : null,
                      child: isBusy
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(S.current.create_workspace),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _WorkspacePreviewCard extends StatelessWidget {
  const _WorkspacePreviewCard({
    required this.option,
    required this.name,
    required this.ownerName,
  });

  final _IconOption option;
  final String name;
  final String ownerName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: option.backgroundColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: option.backgroundColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: option.backgroundColor,
            child: Icon(option.icon, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(name, style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Text('Owner: $ownerName', style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IconChoice extends StatelessWidget {
  const _IconChoice({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final _IconOption option;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = selected
        ? Theme.of(context).colorScheme.primary
        : Colors.transparent;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            color: option.backgroundColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Icon(option.icon, color: option.backgroundColor.darken()),
        ),
      ),
    );
  }
}

class _BaseBottomSheet extends StatelessWidget {
  const _BaseBottomSheet({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 24,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              height: 4,
              width: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _IconOption {
  const _IconOption({required this.icon, required this.backgroundColor});

  final IconData icon;
  final Color backgroundColor;
}

class WorkspaceCreationResult {
  const WorkspaceCreationResult({
    required this.workspaceId,
    required this.workspaceName,
  });

  final String workspaceId;
  final String workspaceName;
}

extension on Color {
  Color darken([double amount = 0.2]) {
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
}

const List<_IconOption> _iconOptions = [
  _IconOption(icon: Icons.home_rounded, backgroundColor: Color(0xFF8E7CFF)),
  _IconOption(icon: Icons.groups_rounded, backgroundColor: Color(0xFF7BD88A)),
  _IconOption(
    icon: Icons.business_center_rounded,
    backgroundColor: Color(0xFFFFB74D),
  ),
  _IconOption(
    icon: Icons.apartment_rounded,
    backgroundColor: Color(0xFF66BFFF),
  ),
  _IconOption(
    icon: Icons.track_changes_rounded,
    backgroundColor: Color(0xFFFF8A65),
  ),
  _IconOption(icon: Icons.savings_rounded, backgroundColor: Color(0xFFFFCF66)),
  _IconOption(
    icon: Icons.attach_money_rounded,
    backgroundColor: Color(0xFF4DB6AC),
  ),
  _IconOption(icon: Icons.wb_sunny_rounded, backgroundColor: Color(0xFFFFE082)),
];
