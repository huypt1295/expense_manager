import 'package:expense_manager/features/categories/domain/entities/category_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';

class ExpenseFormFields extends StatelessWidget {
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

  const ExpenseFormFields({
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
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTitleField(),
          const SizedBox(height: 16),
          _buildAmountField(),
          const SizedBox(height: 16),
          _buildCategoryDropdown(),
          const SizedBox(height: 16),
          _buildDatePicker(),
          const SizedBox(height: 16),
          _buildDescriptionField(),
        ],
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: titleController,
      decoration: const InputDecoration(
        labelText: 'Title',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a title';
        }
        return null;
      },
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
      controller: amountController,
      keyboardType: TextInputType.number,
      inputFormatters: const [VndCurrencyInputFormatter()],
      decoration: const InputDecoration(
        labelText: 'Amount',
        border: OutlineInputBorder(),
      ),
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
    );
  }

  Widget _buildCategoryDropdown() {
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
      return InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Category',
          border: OutlineInputBorder(),
        ),
        child: const Text('No categories available'),
      );
    }

    return DropdownButtonFormField<String>(
      value: selectedCategoryId,
      decoration: const InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(),
      ),
      items: categories
          .map(
            (category) => DropdownMenuItem<String>(
              value: category.id,
              child: Text(category.nameForLocale(localeCode)),
            ),
          )
          .toList(),
      onChanged: onCategoryChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a category';
        }
        return null;
      },
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: onDateSelected,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Date: ${selectedDate.toString().split(' ')[0]}',
              style: const TextStyle(fontSize: 16),
            ),
            const Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: descriptionController,
      maxLines: 3,
      decoration: const InputDecoration(
        labelText: 'Description (Optional)',
        border: OutlineInputBorder(),
      ),
    );
  }
}
