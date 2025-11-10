import 'package:expense_manager/features/workspace/domain/entities/workspace_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart';

class WorkspaceRoleBadge extends StatelessWidget {
  const WorkspaceRoleBadge({super.key, required this.workspace});

  final WorkspaceEntity? workspace;

  @override
  Widget build(BuildContext context) {
    final current = workspace;
    if (current == null) {
      return const SizedBox.shrink();
    }

    final label = _roleLabel(current);
    if (label.isEmpty) {
      return const SizedBox.shrink();
    }

    return Chip(
      side: BorderSide.none,
      label: Text(
        label,
        style: TPTextStyle.bodyS.copyWith(
          color: context.tpColors.textMain,
        ),
      ),
      backgroundColor: context.tpColors.surfaceNeutralComponent,
      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  String _roleLabel(WorkspaceEntity workspace) {
    if (workspace.isPersonal) {
      return 'Không gian cá nhân';
    }
    final role = workspace.role.toLowerCase().trim();
    switch (role) {
      case 'owner':
        return 'Vai trò: Chủ sở hữu';
      case 'editor':
        return 'Vai trò: Có thể chỉnh sửa';
      case 'viewer':
        return 'Vai trò: Chỉ xem';
      default:
        if (role.isEmpty) {
          return '';
        }
        final capitalized = role[0].toUpperCase() + role.substring(1);
        return 'Vai trò: $capitalized';
    }
  }
}
