import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_resource/flutter_resource.dart';

class WorkspaceInfoCard extends StatelessWidget {
  const WorkspaceInfoCard({
    super.key,
    required this.name,
    required this.onEditNameTap,
  });

  final String name;
  final VoidCallback onEditNameTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.tpColors.surfaceNeutral,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.tpColors.borderNeutralComponent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("🏠", style: TPTextStyle.titleL),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TPTextStyle.titleM.copyWith(
                        color: context.tpColors.textMain,
                      ),
                    ),
                    const SizedBox(height: 4),
                    InkWell(
                      onTap: onEditNameTap,
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            color: context.tpColors.textLink,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            S.current.edit_name,
                            style: TPTextStyle.bodyM.copyWith(
                              color: context.tpColors.textLink,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      S.current.workspace_info_content,
                      style: TPTextStyle.bodyM.copyWith(
                        color: context.tpColors.textSub,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
