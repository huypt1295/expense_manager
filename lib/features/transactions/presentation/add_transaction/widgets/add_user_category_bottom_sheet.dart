import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';

class AddUserCategoryBottomSheet extends StatefulWidget {
  const AddUserCategoryBottomSheet({super.key, required this.initialType});

  final TransactionType initialType;

  @override
  State<AddUserCategoryBottomSheet> createState() =>
      _AddUserCategoryBottomSheetState();
}

class _AddUserCategoryBottomSheetState
    extends State<AddUserCategoryBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _iconController = TextEditingController();
  late TransactionType _type;

  @override
  void initState() {
    super.initState();
    _type = widget.initialType;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 24,
          bottom: viewInsets + 24,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Thêm danh mục',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              CommonTextFormField(
                controller: _nameController,
               hintText: "Tên danh mục",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tên danh mục';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CommonTextFormField(
                controller: _iconController,
                hintText: "Biểu tượng (emoji)",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập emoji';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TransactionType>(
                value: _type,
                decoration: const InputDecoration(labelText: 'Loại giao dịch'),
                items: TransactionType.values
                    .map(
                      (type) => DropdownMenuItem<TransactionType>(
                        value: type,
                        child: Text(_labelForType(type)),
                      ),
                    )
                    .toList(growable: false),
                onChanged: (type) {
                  if (type != null) {
                    setState(() {
                      _type = type;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Huỷ'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Lưu'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    Navigator.of(context).pop(
      UserCategoryDraft(
        name: _nameController.text.trim(),
        icon: _iconController.text.trim(),
        type: _type,
      ),
    );
  }

  static String _labelForType(TransactionType type) {
    switch (type) {
      case TransactionType.expense:
        return 'Chi tiêu';
      case TransactionType.income:
        return 'Thu nhập';
    }
  }
}

class UserCategoryDraft {
  const UserCategoryDraft({
    required this.name,
    required this.icon,
    required this.type,
  });

  final String name;
  final String icon;
  final TransactionType type;
}
