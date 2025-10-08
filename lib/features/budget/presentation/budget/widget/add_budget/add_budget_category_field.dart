import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_bloc.dart';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_event.dart';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';

class AddBudgetCategoryField extends BaseStatelessWidget {
  const AddBudgetCategoryField({
    super.key,
    required this.selectedCategoryId,
    required this.onCategoryIdChanged,
  });

  final String? selectedCategoryId;
  final ValueChanged<String?> onCategoryIdChanged;

  @override
  Widget buildContent(BuildContext context) {
    return BlocBuilder<BudgetBloc, BudgetState>(
      buildWhen: (previous, current) =>
          previous.categories != current.categories ||
          previous.areCategoriesLoading != current.areCategoriesLoading ||
          previous.categoriesError != current.categoriesError,
      builder: (context, state) {
        return _buildCategoryField(context, state);
      },
    );
  }

  Widget _buildCategoryField(BuildContext context, BudgetState state) {
    if (state.areCategoriesLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final categoriesError = state.categoriesError;
    if (categoriesError != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            categoriesError,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => context.read<BudgetBloc>().add(
              const BudgetCategoriesRequested(forceRefresh: true),
            ),
            child: const Text('Retry'),
          ),
        ],
      );
    }

    final categories = state.categories;
    if (categories.isEmpty) {
      return const Text('No categories available');
    }

    final localeCode =
        Localizations.maybeLocaleOf(context)?.languageCode ?? 'en';

    return DropdownButtonFormField<String>(
      initialValue: selectedCategoryId,
      decoration: const InputDecoration(labelText: 'Category'),
      items: categories
          .map(
            (category) => DropdownMenuItem<String>(
              value: category.id,
              child: Text(category.nameForLocale(localeCode)),
            ),
          )
          .toList(growable: false),
      onChanged: onCategoryIdChanged,
    );
  }
}
