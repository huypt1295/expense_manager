import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:expense_manager/features/transactions/presentation/add_transaction/widgets/add_expense_or_income_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_resource/l10n/gen/l10n.dart';

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
    return CommonBottomSheet(
      title: S.current.add_category,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => ViewUtils.hideKeyboard(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTypeSelection(),
                const SizedBox(height: 24),
                _buildCategoryName(),
                const SizedBox(height: 16),
                _buildCategoryIcon(),
                const SizedBox(height: 24),
                _buildActionButton(context),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelection() {
    return AddExpenseOrIncomeSelection(
      selectedType: _type,
      onTypeChanged: (type) {
        setState(() {
          _type = type;
        });
      },
    );
  }

  Widget _buildCategoryName() {
    return CommonTextFormField(
      controller: _nameController,
      hintText: S.current.category_name,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return S.current.please_enter_category_name;
        }
        return null;
      },
    );
  }

  Widget _buildCategoryIcon() {
    return CommonTextFormField(
      controller: _iconController,
      hintText: S.current.choose_icon,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return S.current.please_choose_icon;
        }
        return null;
      },
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return CommonPrimaryButton(
      onPressed: () {
        _submit();
      },
      padding: EdgeInsets.zero,
      child: Text(S.current.save,
        style: TextStyle(fontSize: 16),
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
