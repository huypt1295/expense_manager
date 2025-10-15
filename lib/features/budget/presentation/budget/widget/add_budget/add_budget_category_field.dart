import 'package:expense_manager/core/enums/transaction_type.dart';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_bloc.dart';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_event.dart';
import 'package:expense_manager/features/budget/presentation/budget/bloc/budget_state.dart';
import 'package:expense_manager/features/transactions/presentation/add_transaction/widgets/add_expense_category_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_resource/flutter_resource.dart' show TPTextStyle;
import 'package:flutter_resource/l10n/gen/l10n.dart';

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

    final categories = state.categories
        .where((category) => category.type == TransactionType.expense)
        .toList(growable: false);
    if (categories.isEmpty) {
      return const Text('No categories available');
    }

    final localeCode =
        Localizations.maybeLocaleOf(context)?.languageCode ?? 'en';
    final initialValue =
        categories.any((category) => category.id == selectedCategoryId)
        ? selectedCategoryId
        : null;
    final textTheme = Theme.of(context).textTheme;

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
          initialValue: initialValue,
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
                CommonGridView(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = state.value == category.id;
                    return CategoryGridItem(
                      category: category,
                      isSelected: isSelected,
                      localeCode: localeCode,
                      onTap: () {
                        state.didChange(category.id);
                        onCategoryIdChanged(category.id);
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
}
