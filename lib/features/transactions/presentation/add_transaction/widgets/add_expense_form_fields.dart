import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';
import 'package:expense_manager/features/transactions/presentation/add_transaction/widgets/add_expense_category_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_resource/flutter_resource.dart';

class AddExpenseFormFields extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController amountController;
  final TextEditingController descriptionController;
  final String? selectedCategoryId;
  final DateTime selectedDate;
  final List<CategoryEntity> categories;
  final Function(String?) onCategoryChanged;
  final VoidCallback onDateSelected;
  final String localeCode;
  final bool categoriesLoading;
  final String? categoriesError;
  final VoidCallback onRetryCategories;
  final VoidCallback? onAddCategoryTap;

  const AddExpenseFormFields({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.amountController,
    required this.descriptionController,
    required this.selectedCategoryId,
    required this.selectedDate,
    required this.categories,
    required this.onCategoryChanged,
    required this.onDateSelected,
    required this.localeCode,
    required this.categoriesLoading,
    required this.categoriesError,
    required this.onRetryCategories,
    this.onAddCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTitleField(context),
            const SizedBox(height: 24),
            _buildAmountField(context),
            const SizedBox(height: 16),
            _buildCategoryList(context),
            const SizedBox(height: 16),
            _buildDatePicker(context),
            const SizedBox(height: 16),
            _buildDescriptionField(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.current.title,
          style: TPTextStyle.bodyM.copyWith(color: context.tpColors.textMain),
        ),
        const SizedBox(height: 8),
        CommonTextFormField(
          controller: titleController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a title';
            }
            return null;
          },
          hintText: "Title",
        ),
      ],
    );
  }

  Widget _buildAmountField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.current.amount,
          style: TPTextStyle.bodyM.copyWith(color: context.tpColors.textMain),
        ),
        const SizedBox(height: 8),
        CommonTextFormField(
          controller: amountController,
          keyboardType: TextInputType.number,
          inputFormatters: const [VndCurrencyInputFormatter()],
          hintText: "Amount",
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an amount';
            }
            final parsed = CurrencyUtils.parseVndToDouble(value);
            if (parsed == null) {
              return 'Please enter a valid number';
            }
            if (parsed <= 0) {
              return 'Amount must be greater than 0';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCategoryList(BuildContext context) {
    if (categoriesLoading) {
      return InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Category',
          border: OutlineInputBorder(),
        ),
        child: const SizedBox(
          height: 48,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (categoriesError != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            child: Text(
              categoriesError!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: onRetryCategories,
            child: const Text('Retry'),
          ),
        ],
      );
    }

    if (categories.isEmpty) {
      return const Text('No categories available');
    }

    final textTheme = Theme.of(context).textTheme;
    final totalItems = categories.length + 1;
    final crossAxisCount = totalItems >= 3 ? 3 : totalItems;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.current.category,
          style: TPTextStyle.bodyM.copyWith(color: context.tpColors.textMain),
        ),
        const SizedBox(height: 8),
        FormField<String>(
          key: ValueKey<String?>(selectedCategoryId),
          initialValue: selectedCategoryId,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a category';
            }
            return null;
          },
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemCount: totalItems,
                  itemBuilder: (context, index) {
                    if (index == categories.length) {
                      return AddCategoryGridItem(onTap: onAddCategoryTap);
                    }
                    final category = categories[index];
                    final isSelected = state.value == category.id;
                    return CategoryGridItem(
                      category: category,
                      isSelected: isSelected,
                      localeCode: localeCode,
                      onTap: () {
                        state.didChange(category.id);
                        onCategoryChanged(category.id);
                      },
                    );
                  },
                ),
                if (state.hasError) ...[
                  const SizedBox(height: 8),
                  Text(
                    state.errorText!,
                    style: textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.current.date_time,
          style: TPTextStyle.bodyM.copyWith(color: context.tpColors.textMain),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onDateSelected,
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: context.tpColors.borderDefault),
              borderRadius: BorderRadius.circular(16),
              color: context.tpColors.surfaceSub,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat.yMEd().format(selectedDate),
                  style: const TextStyle(fontSize: 16),
                ),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.current.note,
          style: TPTextStyle.bodyM.copyWith(color: context.tpColors.textMain),
        ),
        const SizedBox(height: 8),
        CommonTextFormField(
          controller: descriptionController,
          hintText: S.current.note_hint,
        ),
      ],
    );
  }
}
