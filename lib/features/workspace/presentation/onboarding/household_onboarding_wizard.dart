import 'package:expense_manager/core/auth/current_user.dart';
import 'package:expense_manager/features/workspace/presentation/onboarding/cubit/household_onboarding_cubit.dart';
import 'package:expense_manager/features/workspace/presentation/onboarding/cubit/household_onboarding_state.dart';
import 'package:expense_manager/features/workspace/presentation/settings/workspace_management_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';

class HouseholdOnboardingWizard {
  const HouseholdOnboardingWizard._();

  static Future<void> show(BuildContext context) async {
    final shouldCreate = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _WorkspaceEmptySheet(),
    );

    if (shouldCreate != true) {
      return;
    }

    final creationResult =
        await showModalBottomSheet<_HouseholdCreationResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider(
        create: (_) => tpGetIt.get<HouseholdOnboardingCubit>(),
        child: const _WorkspaceCreateSheet(),
      ),
    );

    if (creationResult == null) {
      return;
    }

    await WorkspaceManagementSheet.show(
      context,
      householdId: creationResult.householdId,
      householdName: creationResult.householdName,
      currentRole: 'owner',
    );
  }
}

class _WorkspaceEmptySheet extends StatelessWidget {
  const _WorkspaceEmptySheet();

  @override
  Widget build(BuildContext context) {
    return _BaseBottomSheet(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Workspace',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(false),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: CircleAvatar(
                radius: 36,
                backgroundColor:
                    Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  Icons.group_outlined,
                  size: 36,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Bạn chưa tham gia workspace nào',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Tạo workspace để chia sẻ giao dịch và ngân sách với gia đình hoặc đồng nghiệp',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => Navigator.of(context).maybePop(true),
                icon: const Icon(Icons.add),
                label: const Text('Tạo workspace'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkspaceCreateSheet extends StatefulWidget {
  const _WorkspaceCreateSheet();

  @override
  State<_WorkspaceCreateSheet> createState() => _WorkspaceCreateSheetState();
}

class _WorkspaceCreateSheetState extends State<_WorkspaceCreateSheet> {
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
    return BlocConsumer<HouseholdOnboardingCubit, HouseholdOnboardingState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage ||
          previous.completedHouseholdId != current.completedHouseholdId,
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
        if (state.isCompleted) {
          Navigator.of(context).maybePop(
            _HouseholdCreationResult(
              householdId: state.completedHouseholdId!,
              householdName: state.name.trim(),
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
        final owner =
            tpGetIt.get<CurrentUser>().now()?.displayName ?? 'Bạn';
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
                        onPressed:
                            isBusy ? null : () => Navigator.of(context).maybePop(),
                        child: const Text('Hủy'),
                      ),
                      Expanded(
                        child: Text(
                          'Tạo workspace',
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
                    'Chọn icon',
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
                            : () =>
                                context.read<HouseholdOnboardingCubit>().selectIcon(index),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _controller,
                    enabled: !isBusy,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Tên workspace',
                      hintText: 'VD: Gia đình Nguyễn',
                    ),
                    onChanged: context.read<HouseholdOnboardingCubit>().updateName,
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
                          ? () =>
                              context.read<HouseholdOnboardingCubit>().submit()
                          : null,
                      child: isBusy
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Tạo workspace'),
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
            child: Icon(
              option.icon,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Owner: $ownerName',
                  style: theme.textTheme.bodySmall,
                ),
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
            border: Border.all(
              color: borderColor,
              width: 2,
            ),
          ),
          child: Icon(
            option.icon,
            color: option.backgroundColor.darken(),
          ),
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
  const _IconOption({
    required this.icon,
    required this.backgroundColor,
  });

  final IconData icon;
  final Color backgroundColor;
}

class _HouseholdCreationResult {
  const _HouseholdCreationResult({
    required this.householdId,
    required this.householdName,
  });

  final String householdId;
  final String householdName;
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
  _IconOption(icon: Icons.business_center_rounded, backgroundColor: Color(0xFFFFB74D)),
  _IconOption(icon: Icons.apartment_rounded, backgroundColor: Color(0xFF66BFFF)),
  _IconOption(icon: Icons.track_changes_rounded, backgroundColor: Color(0xFFFF8A65)),
  _IconOption(icon: Icons.savings_rounded, backgroundColor: Color(0xFFFFCF66)),
  _IconOption(icon: Icons.attach_money_rounded, backgroundColor: Color(0xFF4DB6AC)),
  _IconOption(icon: Icons.wb_sunny_rounded, backgroundColor: Color(0xFFFFE082)),
];
